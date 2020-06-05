# Building EDK2 for RISC-V

Prerequisites: Docker, QEMU, Built kernel, initramfs, DTB
Optional: libnotify

```sh
# Create a working directory and enter it
mkdir edk2-riscv
cd edk2-riscv

# Clone all repositories with submodules
git clone https://github.com/JohnAZoidberg/riscv-edk2-docker
git clone --depth=1 --recurse-submodules --branch=esp-ramdisk https://github.com/riscv/riscv-edk2 edk2
git clone --depth=1 --recurse-submodules --branch=riscv-dt-fixup-ramdisk https://github.com/riscv/riscv-edk2-platforms edk2-platforms

# Download and unpack the RISC-V
wget https://github.com/riscv/riscv-uefi-edk2-docs/raw/master/gcc-riscv-edk2-ci-toolchain/gcc-riscv-9.2.0-2020.04-x86_64_riscv64-unknown-gnu.tar.xz
tar xf gcc-riscv-9.2.0-2020.04-x86_64_riscv64-unknown-gnu.tar.xz
rm gcc-riscv-9.2.0-2020.04-x86_64_riscv64-unknown-gnu.tar.xz

# Now you can work from within this repo
cd riscv-edk2-docker

# Build the docker container
docker build -t edk2 .

# Start the docker container
./rundocker.sh

# Make linux iso for ramdisk
mkfs.msdos -C linux.iso 14000
sudo losetup /dev/loop0 linux.iso
sudo mount /dev/loop0 /mnt
# Copy the kernel and initramfs that you built previously
sudo cp linux-riscv64.efi /mnt
sudo cp initramfs.cpio /mnt
sudo umount /mnt
sudo losetup -d /dev/loop0
mv linux.iso Silicon/RISC-V/ProcessorPkg/Universal/EspRamdisk/linux.iso

# Copy the device tree into EDK2 build directory
cp U540.dtb Platform/RISC-V/PlatformPkg/Universal/Sec/Riscv64/U540.dtb

# Build EDK2
./build-in-docker.sh

# Run generated FW image U540.fd with QEMU
./runqemu.sh
```

#### Run Linux from embedded ramdisk in EFI Shell
```
# Mount ramdisk and open disk
embeddedramdisk 4f2f3d7b-35ef-411b-9d26-e76ecacbaf8b
map -r
fs0:

# Launch Linux with your favourite arguments, for example:
linux-riscv64.efi console=ttyS0 earlycon early_ioremap_debug initrd=\initramfs.cpio
```
