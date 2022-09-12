FROM python:3.9

RUN mkdir /app
ADD example_plugin.py /app
ADD test_example_plugin.py /app
ADD requirements.txt /app
WORKDIR /app

RUN pip install -r requirements.txt

RUN mkdir /htmlcov
RUN pip install coverage
RUN /usr/local/bin/python3 -m coverage run test_example_plugin.py
RUN /usr/local/bin/python3 -m coverage html -d /htmlcov

VOLUME /config

ENTRYPOINT ["/usr/local/bin/python3", "/app/example_plugin.py"]
CMD ["-f", "/config/example.yaml"]