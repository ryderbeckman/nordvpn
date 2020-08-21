FROM amd64/debian:bullseye-slim

ARG NORDVPN_VERSION
LABEL maintainer="Your Mom"

HEALTHCHECK --interval=5m --timeout=20s --start-period=1m \
  CMD if test $( curl -m 10 -s https://api.nordvpn.com/vpn/check/full | jq -r '.["status"]' ) = "Protected" ; then exit 0; else nordvpn connect ${CONNECT} ; exit $?; fi

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y wget && \
    wget -O /tmp/nordrepo.deb https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/nordvpn-release_1.0.0_all.deb && \
    apt install -y /tmp/nordrepo.deb && \
    apt update && \
    apt install -y nordvpn && \
    apt remove -y wget nordvpn-release

ENTRYPOINT["/usr/sbin/nordvpnd","&"]
