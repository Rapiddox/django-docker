# First steps

First you have to run this command:
```bash
cp .env.dist .env
```
It has all the necessary `environment` key value pairs to run the project locally

After that you have to add this line to your hosts file (`/etc/hosts`):
```
127.0.0.1   app.core-local.com
```
This makes sure that you can access the project on this host

If the traefik_proxy is not running you should run this command first:
```bash
make traefik-start
```

You should run this command if the above doesn't work, then try again:
```bash
make docker-network-create
```

If you just cloned the repo you should run this command:
```bash
make install
```
this command starts the docker containers and do the basic initializations

If you have already ran the previous command you should use:
```bash
make up
```
this command skips the installation parts and migration parts to the database and simply just starts the containers

After that if you open [app.core-local.com](http://app.core-local.com) then you should see the default django welcome page!

# Assets

If you want to build the assets, then run this command:
```bash
make build-assets
```

And if you want to watch for changes in the assets then run this command:
```bash
make watch-assets
```

The basic idea behind the asset management is that following the "django" app manner.

So you should follow this structure like:
`assets/js/<app_name>/<name>.(js|ts)` and same with css.

When running the `make build-assets` command then it will build the files into the `dist` folder and will follow the structure of your assets.
So the output will be `dist/js/<app_name>/<name>.js`.

And you can use it inside the django templates like
```html
{% load static %}
<link rel="stylesheet" href="{% static 'css/<app_name>/<name>.css' %}">
<script src="{% static 'js/<app_name>/<name>.js' %}" defer></script>
```

There is a css file that holds all the tailwindcss styles and it should be used inside the base layout like: `<link rel="stylesheet" href="{% static 'css/app.css' %}">`
