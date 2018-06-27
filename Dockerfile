FROM ubuntu:16.04

ARG RTORRENT_VER=0.9.7
ARG LIBTORRENT_VER=0.13.7
ARG FLOOD_VER=master

RUN apt-get update && apt-get upgrade -y; \
    # apt-get install -y git; \
    # git clone https://github.com/rakshasa/libtorrent.git
    apt-get install -y curl; \
    cd /tmp; \
    curl -L https://github.com/rakshasa/libtorrent/archive/v${LIBTORRENT_VER}.tar.gz | tar xvz; \
    cd libtorrent*
RUN apt-get install -y autoconf libtool g++ make zlib1g-dev pkg-config
# RUN apt-get install -y zlib1g-dev
# RUN apt-get install -y libcppunit-dev
RUN cd /tmp/libtorrent*; ./autogen.sh
RUN apt-get install -y libssl-dev
RUN cd /tmp/libtorrent*; ./configure
RUN cd /tmp/libtorrent*; make -j $(nproc)
RUN cd /tmp/libtorrent*; make install

RUN cd /tmp; curl -L https://github.com/rakshasa/rtorrent/releases/download/v${RTORRENT_VER}/rtorrent-${RTORRENT_VER}.tar.gz | tar xzv
RUN apt-get install -y libcurl4-openssl-dev libncurses-dev

# RUN apt-get install -y git
RUN cd /tmp; curl -L https://github.com/mirror/xmlrpc-c/archive/master.tar.gz | tar xzv; cd xmlrpc-c*/stable; ./configure; make -j $(nproc); make install

RUN cd /tmp/rtorrent*/; ./autogen.sh; ./configure --with-xmlrpc-c; make -j $(nproc); make install
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs
RUN npm install -g node-gyp

RUN cd /tmp; curl -L https://github.com/jfurrow/flood/archive/${FLOOD_VER}.tar.gz | tar xzv; mv flood* /usr/local/flood;

COPY rootfs /

ENTRYPOINT [ "entrypoint.sh" ]