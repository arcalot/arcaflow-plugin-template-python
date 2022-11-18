# build poetry
FROM quay.io/centos/centos:stream8 as poetry

RUN dnf -y module install python39 && dnf -y install python39 python39-pip

ENV PYTHONUNBUFFERED=true
WORKDIR /app

COPY poetry.lock /app/
COPY pyproject.toml /app/

RUN python3.9 -m pip install poetry \
 && python3.9 -m poetry config virtualenvs.in-project true \
 && python3.9 -m poetry install --without dev


# coverage test using poetry venv
FROM poetry as coverage

COPY example_plugin.py /app/
COPY test_example_plugin.py /app/

ENV PATH="/app/.venv/bin:$PATH"

RUN mkdir /htmlcov \
 && python3.9 -m pip install coverage \
 && python3.9 -m coverage run test_example_plugin.py \
 && python3.9 -m coverage html -d /htmlcov --omit=/usr/local/*


# final image
FROM quay.io/centos/centos:stream8

RUN dnf -y module install python39

WORKDIR /app

COPY --from=poetry /app/ /app/
COPY --from=coverage /htmlcov /htmlcov/

ENV PATH="/app/.venv/bin:$PATH"

COPY LICENSE /app/
COPY README.md /app/
COPY example_plugin.py /app/

ENTRYPOINT ["/app/.venv/bin/python3", "/app/example_plugin.py"]
CMD []

LABEL org.opencontainers.image.source="https://github.com/arcalot/arcaflow-plugin-template-python"
LABEL org.opencontainers.image.licenses="Apache-2.0+GPL-2.0-only"
LABEL org.opencontainers.image.vendor="Arcalot project"
LABEL org.opencontainers.image.authors="Arcalot contributors"
LABEL org.opencontainers.image.title="Python Plugin Template"
LABEL io.github.arcalot.arcaflow.plugin.version="1"
