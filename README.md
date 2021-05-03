# Building EDK2 for RISC-V

Prerequisites: Docker, QEMU

Optional: libnotify

```sh
# Create a working directory and enter it
mkdir edk2-riscv
cd edk2-riscv

# Clone all repositories with submodules
git clone https://github.com/JohnAZoidberg/riscv-edk2-docker
git clone --depth=1 --recurse-submodules --branch=riscv-virt-540-mod https://github.com/riscv/riscv-edk2 edk2
git clone --depth=1 --recurse-submodules --branch=riscv-virt-540-mod-opensbi0.9 https://github.com/riscv/riscv-edk2-platforms edk2-platforms

# Now you can work from within this repo
cd riscv-edk2-docker

# Build the docker container (includes correct RISC-V gcc toolchain)
docker build -t edk2 .

# Start the docker container
./rundocker.sh


# Build EDK2
./build-in-docker.sh

# Run generated FW image U540.fd with QEMU
./runqemu.sh
```
