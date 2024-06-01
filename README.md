# nanomq

This is a custom build of the `eqmx/nanomq` docker image.  It is built
with support for TLS/SSL only, and therefore falls between the
"basic" and the "slim" versions as described in the [NanoMQ website].

Other differences between this image and the the official docker image
are set out below.

## Mount points and volumes

The configuration directory has been changed to `/etc/nanomq`.  This can be
used as a docker mount point to load custom configurations.

The default configuration will write logs to a docker volume mounted on
`/var/log/nanomq`.

## Deployment

See the [NanoMQ website] for deployment instructions.

[NanoMQ website]: https://nanomq.io/docs/en/latest/installation/docker.html