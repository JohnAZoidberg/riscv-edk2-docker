FROM ubuntu:20.04
MAINTAINER Daniel Schaefer <daniel.schaefer@hpe.com>

#ENV http_proxy="http://web-proxy.bbn.hpecorp.net:8080/"
#ENV https_proxy="http://web-proxy.bbn.hpecorp.net:8080/"
#ENV HTTP_PROXY="http://web-proxy.bbn.hpecorp.net:8080/"
#ENV HTTPS_PROXY="http://web-proxy.bbn.hpecorp.net:8080/"
#RUN echo "Acquire::http::proxy \"http://web-proxy.bbn.hpecorp.net:8080/\";" >> /etc/apt/apt.conf.d/99-proxy
#RUN echo "Acquire::https::proxy \"http://web-proxy.bbn.hpecorp.net:8080/\";" >> /etc/apt/apt.conf.d/99-proxy

RUN apt-get update
RUN apt-get install -y autoconf automake autotools-dev build-essential bison flex
RUN apt-get install -y build-essential uuid-dev iasl git gcc nasm python3-distutils

RUN apt-get install -y wget
RUN wget https://github.com/riscv/riscv-uefi-edk2-docs/raw/master/gcc-riscv-edk2-ci-toolchain/gcc-riscv-9.2.0-2020.04-x86_64_riscv64-unknown-gnu.tar.xz
RUN tar xf gcc-riscv-9.2.0-2020.04-x86_64_riscv64-unknown-gnu.tar.xz
RUN mv gcc-riscv-9.2.0-2020.04-x86_64_riscv64-unknown-gnu /riscv-gnu-toolchain-binaries
RUN rm gcc-riscv-9.2.0-2020.04-x86_64_riscv64-unknown-gnu.tar.xz

# To be compatible with old ubuntu if the toolchain is built for that
RUN ln -s /usr/lib/x86_64-linux-gnu/libmpfr.so.6 /usr/lib/x86_64-linux-gnu/libmpfr.so.4
