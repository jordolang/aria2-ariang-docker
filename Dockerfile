FROM alpine:3.16.0

ARG ARIANG_VERSION
ARG BUILD_DATE
ARG VCS_REF

ENV ARIA2RPCPORT=8080

LABEL maintainer="jordolang" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.name="aria2-ariang" \
    org.label-schema.description="Aria2 downloader and AriaNg webui Docker image based on Alpine Linux" \
    org.label-schema.version=$ARIANG_VERSION \
    org.label-schema.url="https://github.com/jordolang/aria2-ariang-docker" \
    org.label-schema.license="MIT" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/jordolang/aria2-ariang-docker" \
    org.label-schema.vcs-type="Git" \
    org.label-schema.vendor="jordolang" \
    org.label-schema.schema-version="1.0"

RUN apk update \
    && apk add --no-cache --update caddy aria2 su-exec curl

# AriaNG
WORKDIR /usr/local/www/ariang

RUN curl -L https://github.com/mayswind/AriaNg/releases/download/1.3.8/AriaNg-1.3.8.zip \
    && unzip AriaNg-1.3.8.zip \
    && rm AriaNg-1.3.8.zip \
    && chmod -R 755 ./

WORKDIR /aria2

COPY aria2.conf ./conf-copy/aria2.conf
COPY start.sh ./
COPY Caddyfile /usr/local/caddy/

VOLUME /aria2/data
VOLUME /aria2/conf

EXPOSE 8080

ENTRYPOINT ["./start.sh"]
CMD ["--conf-path=/aria2/conf/aria2.conf"]
