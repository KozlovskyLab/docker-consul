FROM alpine:latest
MAINTAINER Vladimir Kozlovski <inbox@vladkozlovski.com>

ENV CONSUL_VERSION 0.7.0
ENV CONSUL_SHA256 b350591af10d7d23514ebaa0565638539900cdb3aaa048f077217c4c46653dd8
ENV CONSUL_WEBUI_SHA256 42212089c228a73a0881a5835079c8df58a4f31b5060a3b4ffd4c2497abe3aa8

RUN apk --update add curl ca-certificates && \
    #curl -Ls https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-2.21-r2.apk > /tmp/glibc-2.21-r2.apk && \
    #apk add --allow-untrusted /tmp/glibc-2.21-r2.apk && \
    rm -rf /tmp/glibc-2.21-r2.apk /var/cache/apk/*

ADD https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip /tmp/consul.zip
RUN echo "${CONSUL_SHA256}  /tmp/consul.zip" > /tmp/consul.sha256 && \
    sha256sum -c /tmp/consul.sha256 && \
    cd /bin && \
    unzip /tmp/consul.zip && \
    chmod +x /bin/consul && \
    rm /tmp/consul.zip

ADD ./config /config/
ADD https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_web_ui.zip /tmp/webui.zip
RUN echo "${CONSUL_WEBUI_SHA256}  /tmp/webui.zip" > /tmp/webui.sha256 && \
    sha256sum -c /tmp/webui.sha256 && \
    cd /tmp && \
    mkdir /ui && \
    unzip webui.zip -d /ui && \
    rm webui.zip

EXPOSE 8300 8301 8301/udp 8302 8302/udp 8400 8500 8600 8600/udp
ENV DNS_RESOLVES consul
ENV DNS_PORT 8600

ENTRYPOINT ["/bin/consul", "agent", "-server", "-config-dir=/config"]
