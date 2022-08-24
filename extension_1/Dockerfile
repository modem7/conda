# syntax = docker/dockerfile-upstream:master-labs

FROM conda:test AS extension1

# Copy entrypoint script
COPY --link --chmod=755 entrypoint.sh /

# Copy config file
COPY --link --chmod=755 example.conf /config/

# Copy example script
COPY --link --chmod=755 example2.sh /config/

# Uncomment this if you want the ps package which gives better process/troubleshooting visibility
# RUN --mount=type=cache,id=aptcache,target=/var/cache/apt,sharing=locked \
    # --mount=type=cache,id=libcache,target=/var/lib/apt,sharing=locked \
    # <<EOF
    # set -e
    # rm -fv /etc/apt/apt.conf.d/docker-clean
    # echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
    # apt-get update
    # apt-get --no-install-recommends install -y procps
# EOF

# System requirements
### Adjust as required

# System Volumes
VOLUME /config

# Document ports that need exposing.
# See the following for more information:
# https://www.ipspace.net/kb/DockerSvc/10-Exposed.html
# https://www.ipspace.net/kb/DockerSvc/20-Published.html
# https://docs.docker.com/engine/reference/run/#expose-incoming-ports
EXPOSE 8282/tcp
EXPOSE 8282/udp