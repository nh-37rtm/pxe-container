FROM stackbrew/debian:jessie

ENV ARCH amd64
ENV DIST stretch
ENV MIRROR http://ftp.nl.debian.org

RUN apt-get -q update
RUN apt-get -qy install \
    dnsmasq \ 
    wget \
    iptables \
    tcpdump \
    traceroute

RUN wget --no-check-certificate https://raw.github.com/jpetazzo/pipework/master/pipework

WORKDIR /tftp
RUN wget $MIRROR/debian/dists/$DIST/main/installer-$ARCH/current/images/netboot/debian-installer/$ARCH/linux
RUN wget $MIRROR/debian/dists/$DIST/main/installer-$ARCH/current/images/netboot/debian-installer/$ARCH/initrd.gz
RUN wget $MIRROR/debian/dists/$DIST/main/installer-$ARCH/current/images/netboot/debian-installer/$ARCH/pxelinux.0
RUN mkdir pxelinux.cfg

RUN mkdir -p /usr/local

COPY ./pxe/start.sh /usr/local/start.sh
COPY ./pxe/etc/dnsmasq.conf /etc/dnsmasq.conf

# for CMD let see docker-compose


