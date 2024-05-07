#!/usr/bin/env bash

path=$(pwd)

cat << EOF >> ~/.bashrc

export PATH="$path:\$PATH"
export PATH="${path}/riscv32/bin:\$PATH"
export PATH="${path}/riscv64/bin:\$PATH"

alias gccrv32="riscv32-unknown-elf-gcc"
alias dumprv32="riscv32-unknown-elf-objdump"
alias runrv32="qemu-riscv32"

alias gccrv64="riscv64-unknown-elf-gcc"
alias dumprv64="riscv64-unknown-elf-objdump"
alias runrv64="qemu-riscv64"

EOF

curl -L -o 32.tar.gz https://github.com/riscv-collab/riscv-gnu-toolchain/releases/download/2024.04.12/riscv32-elf-ubuntu-22.04-gcc-nightly-2024.04.12-nightly.tar.gz
mkdir riscv32
tar -xvf 32.tar.gz -C riscv32 --strip-components=1 && rm 32.tar.gz

curl -L -o 64.tar.gz https://github.com/riscv-collab/riscv-gnu-toolchain/releases/download/2024.04.12/riscv64-elf-ubuntu-22.04-gcc-nightly-2024.04.12-nightly.tar.gz
mkdir riscv64
tar -xvf 64.tar.gz -C riscv64 --strip-components=1 && rm 64.tar.gz

