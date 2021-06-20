FROM alpine:latest

RUN apk update && \
    apk upgrade && \
    apk add --no-cache mariadb-client

COPY ./scripts/daily/* /etc/periodic/daily
COPY ./scripts/restore-database /opt/mysql/

RUN chmod a+x /etc/periodic/daily/* /opt/mysql/*