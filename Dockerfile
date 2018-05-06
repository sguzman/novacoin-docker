FROM ubuntu:latest

RUN apt-get update
RUN apt-get install -y git qt4-qmake libqt4-dev build-essential libboost-dev libboost-system-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev libdb++-dev libqrencode-dev libssl1.0-dev libz-dev

WORKDIR ~
RUN git clone https://github.com/novacoin-project/novacoin.git
WORKDIR novacoin
RUN qmake USE_O3=1 USE_ASM=1 USE_LEVELDB=1 RELEASE=1 STATIC=1
RUN make
WORKDIR src
RUN make -f makefile.unix USE_O3=1 USE_ASM=1 USE_LEVELDB=1 RELEASE=1 STATIC=1
RUN strip novacoind
RUN cp novacoind /root/novacoind
WORKDIR ~
RUN ~/novacoind -server -printtoconsole -logtimestamps -updgradewallet -par=8
