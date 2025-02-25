FROM python:3.8-slim-buster

ENV PYTHONDOWNWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /usr/local/notifyapp

RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y netcat-openbsd gcc && \
    apt-get install -y python3-dev && \
    apt-get install -y libpq-dev && \
    # busybox-static is for crond
    apt-get install -y busybox-static && \
    apt-get install -y cron && \
    apt-get install -y procps && \
    apt-get clean

COPY Pipfile Pipfile.lock /usr/local/notifyapp/

RUN pip install --upgrade pip
RUN pip install 'pipenv==2018.11.26' && pipenv install --dev --system --sequential

ADD cron.d /etc/cron.d/
RUN chmod 644 /etc/cron.d/*
RUN crontab /etc/cron.d/*

COPY . /usr/local/notifyapp/

CMD busybox crond -f -L /dev/stderr



