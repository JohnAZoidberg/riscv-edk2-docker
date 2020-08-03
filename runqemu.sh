#!/bin/sh
qemu-system-riscv64 -cpu sifive-u54 -machine sifive_u \
  -bios U540.fd \
  -m 2048 -nographic -smp cpus=5,maxcpus=5 #\
  #k-serial /dev/pts/20
  #-D qemu-log -d in_asm

  #-hda fat:rw:esp \

  #-drive id=cd0,if=none,format=raw,readonly,file=grub.iso \
  #-device ide-cd,bus=ide.1,drive=cd0 \

  #-drive file=Fedora-Minimal-Rawhide-20200108.n.0-sda.raw,index=0,media=disk,format=raw \
  #-drive file=grub.iso,index=1,media=disk,format=raw \
