include common.mk

BL1 := $(UBOOT_SRC)/sd_fuse/bl1.bin.hardkernel
BL1_0 := oem/boot-assets/bl1-0.bin
BL1_1 := oem/boot-assets/bl1-1.bin
OEM_UBOOT_BIN := oem/boot-assets/u-boot.bin

all: oem

clean:
	rm -f $(BL1_0) $(BL1_1) $(OEM_UBOOT_BIN)

$(BL1_0):
	dd if=$(BL1) of=$@ bs=1 count=442 conv=notrunc

$(BL1_1):
	dd if=$(BL1) of=$@ bs=512 skip=1 conv=notrunc

u-boot:
	@if [ ! -f $(UBOOT_BIN) ] ; then echo "Build u-boot first."; exit 1; fi
	cp -f $(UBOOT_BIN) $(OEM_UBOOT_BIN)

bl: $(BL1_0) $(BL1_1) u-boot

snappy:
	cd oem && snappy build -o $(OUTPUT_DIR) .

oem: bl snappy

.PHONY: u-boot bl snappy oem
