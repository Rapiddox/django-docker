.DEFAULT_GOAL := help

DOCKER_COMPOSE_FILE ?= compose.yml
DC = docker compose -f ${DOCKER_COMPOSE_FILE}
DC_RUN = ${DC} run --rm
POETRY = ${DC_RUN} python poetry
MANAGE_PY = ${POETRY} run python manage.py
NPM = ${DC_RUN} node npm
APP_ENV ?= dev

help:
	@printf "\033[33mUsage:\033[0m\n  make [target]\n\n\033[33mTargets:\033[0m\n"
	@grep -E '(^[a-zA-Z_-]+[%]?:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

.PHONY: help

##-----------------------------------------------------------------------------
##Docker

docker-network-create: ## Creates the traefik_proxy network
	docker network inspect traefik_proxy > /dev/null 2>&1 || docker network create traefik_proxy

check-traefik: ## Check if traefik proxy running
	@(docker ps | grep traefik_proxy) > /dev/null 2>&1 || echo "\n\n\033[0;31m* FIGYELEM!\n* Nem fut a traefik proxy, indítsd el az alábbi leírás alapján:\n* https://github.com/ingatlancom/.github-private/blob/master/docs/environment/configuration.md\n\n\033[0m"

traefik-start: ## Starts the traefik proxy
	docker run --name traefik_proxy -p 8080:8080 -p 80:80 --restart unless-stopped -d --network traefik_proxy -v /var/run/docker.sock:/var/run/docker.sock traefik:v2.9 --providers.docker.endpoint=unix:///var/run/docker.sock --providers.docker.exposedByDefault=false --api.insecure=true

build: ## Build containers
	APP_ENV=${APP_ENV} $(DC) up -d --build

pull: ## Pull images
	$(DC) pull

down: ## Down containers
	$(DC) down --remove-orphans

.PHONY: docker-network-create check-traefik traefik-start pull down build

##-----------------------------------------------------------------------------
##Project

up: ## Starts the project and skips package installing
up: down pull docker-network-create check-traefik build poetry-install

install: ## Installs everything you need and starts the webserver
install: down pull docker-network-create check-traefik build poetry-install migrate npm-install build-assets

poetry-install:
	$(POETRY) install

collectstatic: ## Runs the manage.py collectstatic command
	$(MANAGE_PY) collectstatic

migrate: ## Python manage.py migrate
	$(MANAGE_PY) migrate

npm-install: ## Npm install
	$(NPM) install

build-assets: ## Build assets
	$(NPM) run build

watch-assets: ## Build assets
	$(NPM) run watch

.PHONY: up install poetry-install collectstatic migrate npm-install build-assets watch-assets
