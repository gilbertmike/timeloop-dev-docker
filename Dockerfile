FROM ubuntu:22.04

ENV BUILD_DIR=/usr/local/src
ENV BARVINOK_VER=0.41.7
ENV NTL_VER=11.5.1
ENV ISLPY_VER=2024.2

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
                       libboost-filesystem-dev \
                       libboost-log-dev \
                       libyaml-cpp-dev \
                       libncurses5-dev \
                       libtinfo-dev \
                       libgpm-dev \
                       libgmp-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR $BUILD_DIR
RUN wget https://libntl.org/ntl-$NTL_VER.tar.gz \
    && tar -xvzf ntl-$NTL_VER.tar.gz \
    && cd ntl-$NTL_VER/src \
    && ./configure NTL_GMP_LIP=on SHARED=on \
    && make \
    && make install


WORKDIR $BUILD_DIR
RUN wget https://barvinok.sourceforge.io/barvinok-$BARVINOK_VER.tar.gz \
    && tar -xvzf barvinok-$BARVINOK_VER.tar.gz \
    && cd barvinok-$BARVINOK_VER \
    && ./configure --enable-shared-barvinok \
    && make \
    && make install

WORKDIR $BUILD_DIR
RUN wget -O islpy-$ISLPY_VER.tar.gz https://github.com/inducer/islpy/archive/refs/tags/v$ISLPY_VER.tar.gz \
    && tar -xvzf islpy-$ISLPY_VER.tar.gz \
    && cd islpy-$ISLPY_VER \
    && sed -i 's/python/python3/g' build-with-barvinok.sh \
    && ./build-with-barvinok.sh /usr/local

# Get Python libraries
RUN pip3 install jupyter \
                 numpy \
                 matplotlib \
                 pandas \
                 seaborn
