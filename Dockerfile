FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive
COPY ./gamecoin.conf /root/.gamecoin/gamecoin.conf
COPY . /gamecoin
WORKDIR /gamecoin
#shared libraries and dependencies
RUN apt-get -y update
RUN apt-get install -y build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils wget unzip
RUN apt-get install -y libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev
#BerkleyDB for wallet support
RUN wget http://download.oracle.com/berkeley-db/db-4.8.30.zip
RUN unzip db-4.8.30.zip
WORKDIR /gamecoin/db-4.8.30/dbinc
RUN sed -i 's/__atomic_compare_exchange/__atomic_compare_exchange_db/g' atomic.h
WORKDIR /gamecoin/db-4.8.30/build_unix
RUN ../dist/configure --prefix=/usr/local --enable-cxx
RUN make
RUN make install
#upnp
RUN apt-get install -y libminiupnpc-dev
#ZMQ
RUN apt-get install -y libzmq3-dev
#build gamecoin source
RUN cd ../.. \
&& chmod +x autogen.sh \
&& ./autogen.sh \
&& chmod +x configure
&& ./configure
RUN make
RUN make install
#open service port
EXPOSE 62005 62006
CMD ["gamecoind", "--printtoconsole"]
