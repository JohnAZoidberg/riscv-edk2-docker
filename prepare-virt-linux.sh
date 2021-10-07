#!/bin/sh
#multipath-tools parted
# Enable bash strict mode
set -euo pipefail

# Download prebuilt linux files if they don't exist locally
wget --no-clobber https://danielschaefer.me/static/riscv/ci/Image
wget --no-clobber https://danielschaefer.me/static/riscv/ci/rootfs.cpio
wget --no-clobber https://danielschaefer.me/static/riscv/ci/rootfs.ext2

rm -f esp.iso
fallocate -l 64M esp.iso
# Create GPT partition table and create one EFI System Partition
# TODO: Put ESP and actual root fs on a single disk
parted -h > /dev/null || multipath -h > /dev/null || sudo apt install -y parted multipath-tools # multipath-tools for kpartx
parted esp.iso mklabel gpt --script
parted esp.iso mkpart primary fat32 0% 100% --script
parted esp.iso set 1 esp on --script
# Load image as disk, create filesystem and mount
LOOP_DEV=$(sudo losetup --find --show esp.iso)
sudo kpartx -a "$LOOP_DEV"
sudo mkfs.vfat /dev/mapper/loop*p1
sudo mount /dev/mapper/loop*p1 /mnt
# Copy EFISTUB and initrd to ESP
sudo cp Image /mnt/linux-riscv64.efi
sudo cp rootfs.cpio /mnt/initramfs.cpio
# Create autostart script
# Don't need this anymore. Expect scripts can provide input
#echo 'fs0:' | sudo tee /mnt/startup.nsh
#echo 'initrd initramfs.cpio' | sudo tee -a /mnt/startup.nsh
#echo 'linux-riscv64.efi root=/dev/vda rootwait earlycon' | sudo tee -a /mnt/startup.nsh
# Unmount
sudo umount /mnt
sudo kpartx -d "$LOOP_DEV"
sudo losetup -d "$LOOP_DEV"
echo "Prepared Linux"
