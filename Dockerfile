# Define versions

ARG ALPINE_VERSION=3.18
ARG NANOMQ_VERSION=0.21.10

# -------------------------------------------------------------------------------------------------------
# Build nanomq from source
# -------------------------------------------------------------------------------------------------------

FROM alpine:${ALPINE_VERSION} AS builder

ARG NANOMQ_VERSION

RUN set -x && \
    apk --no-cache add --virtual build-deps git gcc cmake make musl-dev g++ mbedtls-dev && \
    git clone --depth 1 --branch ${NANOMQ_VERSION} --recurse-submodules --shallow-submodules https://github.com/nanomq/nanomq.git nanomq && \
    mkdir -p /nanomq/build && \
    cd /nanomq/build && \
    cmake -DNNG_ENABLE_TLS=ON .. && make


# -------------------------------------------------------------------------------------------------------
# Package
# -------------------------------------------------------------------------------------------------------

FROM alpine:${ALPINE_VERSION}

COPY --from=builder /nanomq/build/nanomq/nanomq /usr/local/nanomq/
COPY --from=builder /nanomq/build/nanomq_cli/nanomq_cli /usr/local/nanomq/
COPY --from=builder /nanomq/etc/nanomq.conf /etc/nanomq.conf
COPY --from=builder /nanomq/deploy/docker/docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

WORKDIR /usr/local/nanomq

RUN ln -s /usr/local/nanomq/nanomq /usr/bin/nanomq && \
    ln -s /usr/local/nanomq/nanomq_cli /usr/bin/nanomq_cli

RUN set -x && \
    apk --no-cache add mbedtls-dev libatomic

EXPOSE 1883 8883

ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]

CMD ["--conf", "/etc/nanomq.conf"]

