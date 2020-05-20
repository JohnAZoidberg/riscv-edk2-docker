#!/bin/sh
docker run --rm  \
  -v $(pwd)/..:/edk2 \
  -v $(pwd)/../../risc-v/riscv-gnu-toolchain-binaries/:/riscv-gnu-toolchain-binaries \
  -v $(pwd)/../../risc-v/edk2-platform-riscv:/edk2-platform-riscv \
  -it edk2 \
  bash
