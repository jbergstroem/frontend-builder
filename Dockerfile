FROM alpine:3.6 as builder
MAINTAINER Johan Bergström <bugs@bergstroem.nu>

RUN apk add --no-cache build-base curl bash cmake git && \
    curl -Ls https://github.com/google/brotli/archive/v1.0.2.tar.gz | tar -xz && \
    curl -Ls https://github.com/google/zopfli/archive/zopfli-1.0.1.tar.gz | tar -xz && \
    cd /brotli-1.0.2/ && ./configure-cmake && make -j2 && strip brotli && \
    cd /zopfli-zopfli-1.0.1/ && make -j2 && strip zopfli


FROM mhart/alpine-node:8.9
MAINTAINER Johan Bergström <bugs@bergstroem.nu>

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="frontend-builder" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/jbergstroem/frontend-builder" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.license="Apache-2.0"

COPY --from=builder /brotli-1.0.2/brotli /usr/bin/brotli
COPY --from=builder /zopfli-zopfli-1.0.1/zopfli /usr/bin/zopfli

VOLUME /app

# Need CC toolchain for things like libsass and image conversion tools :'(
RUN apk add --no-cache git build-base python zlib-dev autoconf automake file