ASM=nasm
ASMFLAGS=-f bin

SRC_DIR=src
BUILD_DIR=build

.PHONY: mbr stage2 all clean

all: mbr stage2

mbr: $(BUILD_DIR)/mbr.bin

$(BUILD_DIR)/mbr.bin: $(SRC_DIR)/mbr/main.asm
	mkdir -p $(BUILD_DIR)
	$(ASM) $(ASMFLAGS) $^ -o $@

stage2: $(BUILD_DIR)/stage2.bin

$(BUILD_DIR)/stage2.bin: $(SRC_DIR)/stage2/main.asm
	mkdir -p $(BUILD_DIR)
	$(ASM) $(ASMFLAGS) $^ -o $@

clean:
	rm -rf $(BUILD_DIR)/*