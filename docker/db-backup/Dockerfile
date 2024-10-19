FROM alpine:latest

LABEL com.prettygreenplants.vendor="Pretty Green Plants" \
      com.prettygreenplants.email="info@prettygreenplants.com"

RUN apk update && \
    apk upgrade && \
    apk add --no-cache mariadb-client

COPY ./scripts/daily/* /etc/periodic/daily
COPY ./scripts/restore-database /opt/mysql/

RUN chmod a+x /etc/periodic/daily/* /opt/mysql/*