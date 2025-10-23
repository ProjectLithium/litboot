set -e

make all

dd if=/dev/zero of=build/disk.img bs=1M count=64

lmbr build/disk.img create
lmbr build/disk.img write_boot_code build/mbr.bin
lmbr build/disk.img mkpart fat32 boot 2 128
lmbr build/disk.img write 0 build/stage2.bin