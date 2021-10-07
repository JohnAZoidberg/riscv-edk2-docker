# Building EDK2 for RISC-V

Prerequisites: Docker, QEMU

Optional: expect

#### Preparation

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
```

#### Build U540 in Docker and run in QEMU
```sh
# Run EDK2 command in container (for example to build U540)
./build-in-docker.sh \
  build -a RISCV64 -t GCC5 -p Platform/SiFive/U5SeriesPkg/FreedomU540HiFiveUnleashedBoard/U540.dsc

# Run generated FW image U540.fd with QEMU
./run-u540.sh

# Or install expect and run automatic tests
./test-u540-uefishell.expect
```

#### Build RiscvVirtPkg in Docker and run in QEMU
```sh
./build-in-docker.sh \
  build -a RISCV64 -t GCC5 -p Platform/Qemu/RiscvVirt/RiscvVirt.dsc

sudo ./prepare-virt-linux.sh
./test-virt-linux.expect
```

1a99704945 RiscvVirt: Remove empty space in FV
