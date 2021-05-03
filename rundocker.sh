#!/bin/sh
docker run --rm -d \
  -v $(pwd)/:/docker \
  -v $(pwd)/../edk2:/edk2 \
  -v $(pwd)/../edk2-platforms/:/edk2-platform-riscv \
  -it edk2 \
  bash
