#!/bin/bash
export GCC5_RISCV64_PREFIX=/riscv-gnu-toolchain-binaries/bin/riscv64-unknown-elf-
export PACKAGES_PATH=/edk2:/edk2-platform-riscv
export EDK_TOOLS_PATH=/edk2/BaseTools

source /edk2/edksetup.sh
make -C edk2/BaseTools clean
make -C edk2/BaseTools
make -C edk2/BaseTools/Source/C

source edk2/edksetup.sh BaseTools

cd /docker
build -a RISCV64 -p Platform/SiFive/U5SeriesPkg/FreedomU540HiFiveUnleashedBoard/U540.dsc -t GCC5 \
  && cp -v /Build/FreedomU540HiFiveUnleashed/DEBUG_GCC5/FV/U540.fd /docker/

#build -a RISCV64 -p MdeModulePkg/MdeModulePkg.dsc -t GCC5
#build -a RISCV64 -p CryptoPkg/CryptoPkg.dsc -t GCC5
#build -a RISCV64 -p MdePkg/MdePkg.dsc -t GCC5
#build -a RISCV64 -p OvmfPkg/OvmfPkgRISCV64.dsc -t GCC5
#build -a RISCV64 -p RiscVPkg/RiscVPkg.dsc -t GCC5
