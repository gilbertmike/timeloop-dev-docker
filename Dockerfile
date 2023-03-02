FROM ubuntu:20.04

ENV BUILD_DIR=/usr/local/src
ENV BARVINOK_VER=0.41

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata \
    && apt-get install -y --no-install-recommends \
                       locales \
                       curl \
                       git \
                       wget \
                       python3-dev \
                       python3-pip \
                       scons \
                       make \
                       autotools-dev \
                       autoconf \
                       automake \
                       libtool \
    && apt-get install -y --no-install-recommends \
                       g++ \
                       cmake

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
                       g++ \
                       libconfig++-dev \
                       libboost-dev \
                       libboost-iostreams-dev \
                       libboost-serialization-dev \
                       libyaml-cpp-dev \
                       libncurses5-dev \
                       libtinfo-dev \
                       libgpm-dev \
                       libgmp-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR $BUILD_DIR
RUN git clone https://github.com/libntl/ntl.git \
    && cd ntl/src \
    && ./configure NTL_GMP_LIP=on \
    && make \
    && make install


WORKDIR $BUILD_DIR
RUN wget https://barvinok.sourceforge.io/barvinok-$BARVINOK_VER.tar.gz \
    && tar -xvzf barvinok-$BARVINOK_VER.tar.gz \
    && cd barvinok-$BARVINOK_VER \
    && ./configure \
    && make \
    && make install

