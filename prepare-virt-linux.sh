#!/bin/sh
# Enable bash strict mode
set -euo pipefail

# Download prebuilt linux files if they don't exist locally
wget --no-clobber https://danielschaefer.me/static/riscv/ci/Image
wget --no-clobber https://danielschaefer.me/static/riscv/ci/rootfs.cpio
wget --no-clobber https://danielschaefer.me/static/riscv/ci/rootfs.ext2

mkdir -p fs_esp

# TODO: No reason to use sudo here...
sudo cp Image fs_esp/linux-riscv64.efi
sudo cp rootfs.cpio fs_esp/initramfs.cpio

# Create autostart script
# Don't need this anymore. Expect scripts can provide input
#echo 'fs0:' | sudo tee fs_esp/startup.nsh
#echo 'initrd initramfs.cpio' | sudo tee -a fs_esp/startup.nsh
#echo 'linux-riscv64.efi root=/dev/vda rootwait earlycon' | sudo tee -a fs_esp/startup.nsh

echo "Prepared Linux"
