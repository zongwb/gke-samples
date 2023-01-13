FROM python:3.8.3-slim as Base

ADD app/ /opt/app
WORKDIR /opt/app

COPY requirements-test.txt .

RUN apt-get update \
    && apt-get install -y curl git \
    && apt-get install -y procps \
    && apt-get install -y net-tools

RUN pip install --no-cache-dir -r requirements-test.txt

CMD flask run --host=0.0.0.0 -p 3000
