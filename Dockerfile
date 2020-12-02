FROM ubuntu:20.04
LABEL maintainer "Calidae FTW"

ENV DEBIAN_FRONTEND=noninteractive

RUN \
    true \
    && apt-get update \
    && apt-get upgrade --yes \
    && apt-get install --quiet --yes \
        # ---Installation stuff \
        default-jre \
        file \
        kmod \
        # ---YetToBeVerified stuff \
        apache2-utils \
        ppp \
        expect \
        ipppd \
        iptables \
        iputils-ping \
        iproute2 \
        net-tools \
    && apt-get clean

COPY run.sh /vpn/
RUN chmod u+x /vpn/run.sh

COPY gateway-fix.sh /gateway-fix.sh
RUN chmod u+x /gateway-fix.sh

# ADD https://sslvpn.demo.sonicwall.com/NetExtender.x86_64.tgz /vpn/
COPY NetExtender.x86_64.tgz /vpn/

WORKDIR /vpn

RUN \
    tar xvf NetExtender.x86_64.tgz && \
    cd netExtenderClient && \
    ./install && \
    cd .. && \
    rm NetExtender.x86_64.tgz

CMD ["/vpn/run.sh"]
