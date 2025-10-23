# Litboot

## A simple and lightweight x86 bootloader

### Table of features that are supported

|BIOS|UEFI|MBR|GPT|FAT(12/16/32)|ext(2,3,4)|
|----|----|---|---|-------------|----------|
|Yes |No  |Yes|No |In progress  |No        |

### Building

Install `make, nasm`  
Run `make all`

2 files will be built: stage 1 binary(446 bytes, place before partition table), stage 2 binary(place in special boot partition)

### Usage

#### MBR

Litboot depends on disk partitioning, as it uses special partition to store it's main code.

You can use any partitioning tool, `make_image.sh` uses my own partitioning tool [LMBR](https://github.com/ProjectLithium/lmbr) to create MBR disk image and copy bootloader.

`mbr.bin` is the boot sector code and should be placed in the first 446 bytes before MBR table.  
Stage 2 code should be placed in the first partition(any type but without filesystem), which should be exactly 128 sectors long and have boot flag on(0x80)

#### Loading kernel

Loading kernel is still in progress, come back later or suggest your code :)
