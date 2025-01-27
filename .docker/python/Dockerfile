ARG PYTHON_VERSION

FROM python:${PYTHON_VERSION}

WORKDIR /app

ENV POETRY_HOME="/opt/poetry" \
    VENV_PATH="/opt/pysetup/.venv"

ENV PATH="$POETRY_HOME/bin:$VENV_PATH/bin:$PATH"

RUN apt-get update \
    && apt-get install -y \
    curl

RUN curl -sSL https://install.python-poetry.org | python3 -
