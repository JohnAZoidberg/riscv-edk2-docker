#!/bin/sh
docker run --rm -d \
  -v $(pwd)/:/docker \
  -v $(pwd)/../edk2:/edk2 \
  -v $(pwd)/../gcc-riscv-9.2.0-2020.04-x86_64_riscv64-unknown-gnu/:/riscv-gnu-toolchain-binaries \
  -v $(pwd)/../edk2-platforms/:/edk2-platform-riscv \
  -it edk2 \
  bash
