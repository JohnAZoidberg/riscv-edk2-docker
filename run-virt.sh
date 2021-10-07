#!/bin/sh
qemu-system-riscv64 -machine virt \
-bios Build/RiscvVirt/DEBUG_GCC5/FV/RISCVVIRT.fd \
-m 1024 -nographic -smp cpus=1,maxcpus=1
