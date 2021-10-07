#!/bin/sh

qemu-system-riscv64 \
-cpu sifive-u54 -machine sifive_u \
-bios Build/FreedomU540HiFiveUnleashed/DEBUG_GCC5/FV/U540.fd \
-m 1024 -nographic -smp cpus=5,maxcpus=5
