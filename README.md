# Building EDK2 for RISC-V

Prerequisites: Docker, QEMU

```sh
# Create a working directory and enter it
mkdir edk2-riscv
cd edk2-riscv

# Clone all repositories with submodules
git clone https://github.com/JohnAZoidberg/riscv-edk2-docker
git clone --depth=1 --recurse-submodules https://github.com/tianocore/edk2
git clone --depth=1 --branch=devel-riscvplatforms https://github.com/changab/edk2-platforms

# Download and unpack the RISC-V
wget https://github.com/riscv/riscv-uefi-edk2-docs/raw/master/gcc-riscv-edk2-ci-toolchain/gcc-riscv-9.2.0-2020.04-x86_64_riscv64-unknown-gnu.tar.xz
tar xf gcc-riscv-9.2.0-2020.04-x86_64_riscv64-unknown-gnu.tar.xz
rm gcc-riscv-9.2.0-2020.04-x86_64_riscv64-unknown-gnu.tar.xz

# Now you can work from within this repo
cd edk2-docker

# Build the docker container
docker build -t edk2 .

# Start the docker container
./rundocker.sh

# Build EDK2
./build-in-docker.sh

# Run generated FW image U540.fd with QEMU
./runqemu.sh
```
