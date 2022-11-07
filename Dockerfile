FROM quay.io/centos/centos:stream8

RUN dnf -y module install python39 && dnf -y install python39 python39-pip
RUN mkdir /app
RUN chmod 777 /app
ADD https://raw.githubusercontent.com/arcalot/arcaflow-plugin-template-python/main/LICENSE /app/
ADD README.md /app/
ADD poetry.lock /app/
ADD pyproject.toml /app/
ADD example_plugin.py /app/
ADD test_example_plugin.py /app/
RUN chmod +x /app/example_plugin.py /app/test_example_plugin.py
WORKDIR /app

RUN pip3 install poetry
RUN poetry config virtualenvs.create false
RUN poetry install --without dev
RUN /app/test_example_plugin.py

RUN mkdir /htmlcov
RUN pip3 install coverage
RUN python3 -m coverage run test_example_plugin.py
RUN python3 -m coverage html -d /htmlcov --omit=/usr/local/*

VOLUME /config

ENTRYPOINT ["python3", "/app/example_plugin.py"]
CMD []

LABEL org.opencontainers.image.source="https://github.com/arcalot/arcaflow-plugin-template-python"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.vendor="Arcalot project"
LABEL org.opencontainers.image.authors="Arcalot contributors"
LABEL org.opencontainers.image.title="Python Plugin Template"
LABEL io.github.arcalot.arcaflow.plugin.version="1"
