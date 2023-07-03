ARG package=arcaflow_plugin_template_python

# build poetry
FROM quay.io/centos/centos:stream8 as poetry
ARG package
RUN dnf -y module install python39 && dnf -y install python39 python39-pip

WORKDIR /app

COPY poetry.lock /app/
COPY pyproject.toml /app/

RUN python3.9 -m pip install poetry==1.4.2 \
 && python3.9 -m poetry config virtualenvs.create false \
 && python3.9 -m poetry install --without dev --no-root \
 && python3.9 -m poetry export -f requirements.txt --output requirements.txt --without-hashes

# run tests
COPY ${package}/ /app/${package}
COPY tests /app/${package}/tests

ENV PYTHONPATH /app/${package}
WORKDIR /app/${package}

RUN mkdir /htmlcov
RUN python3.9 -m pip install coverage==7.2.7 \
 && python3.9 -m coverage run tests/test_${package}.py \
 && python3.9 -m coverage html -d /htmlcov --omit=/usr/local/*


# final image
FROM quay.io/centos/centos:stream8
ARG package
RUN dnf -y module install python39 && dnf -y install python39 python39-pip

WORKDIR /app

COPY --from=poetry /app/requirements.txt /app/
COPY --from=poetry /htmlcov /htmlcov/
COPY LICENSE /app/
COPY README.md /app/
COPY ${package}/ /app/${package}

RUN python3.9 -m pip install -r requirements.txt

WORKDIR /app/${package}

ENTRYPOINT ["python3.9", "arcaflow_plugin_template_python.py"]
CMD []

LABEL org.opencontainers.image.source="https://github.com/arcalot/arcaflow-plugin-template-python"
LABEL org.opencontainers.image.licenses="Apache-2.0+GPL-2.0-only"
LABEL org.opencontainers.image.vendor="Arcalot project"
LABEL org.opencontainers.image.authors="Arcalot contributors"
LABEL org.opencontainers.image.title="Python Plugin Template"
LABEL io.github.arcalot.arcaflow.plugin.version="1"
