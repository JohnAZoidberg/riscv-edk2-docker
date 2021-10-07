FROM debian:buster
MAINTAINER Daniel Schaefer <daniel.schaefer@hpe.com>

RUN apt-get update

# Base EDK2 tools
RUN apt-get install -y autoconf automake autotools-dev build-essential bison flex
RUN apt-get install -y build-essential uuid-dev iasl git gcc nasm python3-distutils

# RISC-V GCC toolchain
RUN dpkg --add-architecture riscv64
RUN apt-get install -y gcc-riscv64-linux-gnu g++-riscv64-linux-gnu

# DeviceTree compiler for RISC-V
RUN apt-get install -y device-tree-compiler

# QEMU and expect for testing
# Commented out because it's too old. We need at least QEMU 5 or 6
#RUN apt-get install -y expect qemu-system-misc
