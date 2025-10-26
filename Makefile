ASM=nasm
LD=i686-elf-gcc
CC=i686-elf-gcc

SRC_DIR=src
BUILD_DIR=build

STAGE2_SOURCES_ASM=$(shell find $(SRC_DIR)/stage2 -name "*.asm")
STAGE2_OBJECTS_ASM=$(patsubst $(SRC_DIR)/stage2/%.asm, $(BUILD_DIR)/asm/%.o, $(STAGE2_SOURCES_ASM))

STAGE2_SOURCES_C=$(shell find $(SRC_DIR)/stage2 -name "*.c")
STAGE2_OBJECTS_C=$(patsubst $(SRC_DIR)/stage2/%.c, $(BUILD_DIR)/c/%.o, $(STAGE2_SOURCES_C))

.PHONY: mbr stage2 all clean

all: mbr stage2

mbr: $(BUILD_DIR)/mbr.bin

$(BUILD_DIR)/mbr.bin: $(SRC_DIR)/mbr/main.asm
	mkdir -p $(BUILD_DIR)
	$(ASM) -f bin $^ -o $@

stage2: $(BUILD_DIR)/stage2.bin

$(BUILD_DIR)/stage2.bin: $(STAGE2_OBJECTS_ASM) $(STAGE2_OBJECTS_C)
	mkdir -p $(BUILD_DIR)
	$(LD) -T $(SRC_DIR)/stage2/link.ld -nostdlib -lgcc $^ -o $@

$(BUILD_DIR)/asm/%.o: $(SRC_DIR)/stage2/%.asm
	mkdir -p $(dir $@)
	$(ASM) -f elf $< -o $@

$(BUILD_DIR)/c/%.o: $(SRC_DIR)/stage2/%.c
	mkdir -p $(dir $@)
	$(CC) -ffreestanding -nostdlib -c $< -o $@

clean:
	rm -rf $(BUILD_DIR)/*