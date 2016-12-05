FROM alpine:latest
MAINTAINER Vladimir Kozlovski <inbox@vladkozlovski.com>

ENV CONSUL_VERSION 0.7.1
ENV CONSUL_SHA256 5dbfc555352bded8a39c7a8bf28b5d7cf47dec493bc0496e21603c84dfe41b4b
ENV CONSUL_WEBUI_SHA256 1b793c60e1af24cc470421d0411e13748f451b51d8a6ed5fcabc8d00bfb84264

RUN apk --update add curl ca-certificates && \
    rm -rf /var/cache/apk/*

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
