include common.mk

CC := /usr/bin/arm-linux-gnueabihf-

DEVICE_PREINSTALLED := http://cdimage.ubuntu.com/ubuntu-core/daily-preinstalled/current/wily-preinstalled-core-armhf.device.tar.gz

LINUX_UIMAGE := $(LINUX_SRC)/arch/arm/boot/uImage
LINUX_MODULES := $(LINUX_SRC)/modules
LINUX_DTB := $(LINUX_SRC)/arch/arm/boot/dts/meson8b_odroidc.dtb

DEVICE_UIMAGE := $(DEVICE_SRC)/assets/uImage
DEVICE_DTBS := $(DEVICE_SRC)/assets/dtbs
DEVICE_UINITRD := $(DEVICE_SRC)/assets/uInitrd
DEVICE_MODULES := $(DEVICE_SRC)/system

all: device

clean:
	if test -d "$(LINUX_SRC)" ; then $(MAKE) -C $(LINUX_SRC) mrproper ; fi
	rm -f $(INITRD_IMG) $(DEVICE_UIMAGE) $(DEVICE_UINITRD) $(LINUX_UIMAGE) $(LINUX_MODULES) $(LINUX_DTB)

distclean:
	rm -rf $(wildcard $(LINUX_SRC) $(DEVICE_SRC) $(INITRD_SRC))

$(LINUX_SRC)/.config: $(LINUX_SRC)
	$(MAKE) ARCH=arm CROSS_COMPILE=$(CC) -C $(LINUX_SRC) odroidc_defconfig

$(LINUX_UIMAGE): $(LINUX_SRC)/.config
	rm -f $(LINUX_SRC)/arch/arm/boot/zImage
	rm -f $(LINUX_UIMAGE)
	$(MAKE) ARCH=arm CROSS_COMPILE=$(CC) -C $(LINUX_SRC) -j$(CPUS) uImage

$(LINUX_DTB): $(LINUX_SRC)/.config
	$(MAKE) ARCH=arm CROSS_COMPILE=$(CC) -C $(LINUX_SRC) -j$(CPUS) dtbs

modules: $(LINUX_SRC)/.config
	$(MAKE) ARCH=arm CROSS_COMPILE=$(CC) -C $(LINUX_SRC) -j$(CPUS) modules

kernel: $(LINUX_UIMAGE) $(LINUX_DTB) modules
	rm -f $(DEVICE_UIMAGE)
	$(MAKE) ARCH=arm CROSS_COMPILE=$(CC) -C $(LINUX_SRC) -j$(CPUS) INSTALL_MOD_PATH=$(LINUX_MODULES) INSTALL_MOD_STRIP=1 modules_install
	cp $(LINUX_UIMAGE) $(DEVICE_UIMAGE)
	cp -f $(LINUX_DTB) $(DEVICE_DTBS)/

uinitrd: $(DEVICE_SRC)/preinstalled/initrd.img
	rm -f $(DEVICE_UINITRD)
	mkdir -p $(INITRD_SRC)
	rm -rf $(INITRD_SRC)/*
	lzcat $(DEVICE_SRC)/preinstalled/initrd.img | ( cd $(INITRD_SRC); cpio -i )
	@rm -rf $(INITRD_SRC)/lib/modules
	@rm -rf $(INITRD_SRC)/lib/firmware
	@rm -f $(INITRD_IMG)
	( cd $(INITRD_SRC); find | sort | cpio --quiet -o -H newc ) | lzma > $(INITRD_IMG)
	mkimage -A arm -T ramdisk -C none -n "Snappy Initrd" -d $(INITRD_IMG) $(DEVICE_UINITRD)

device: kernel uinitrd
	rm -f $(DEVICE_TAR)
	rm -rf $(DEVICE_MODULES)
	mkdir -p $(DEVICE_MODULES)
	cp -a $(LINUX_MODULES)/* $(DEVICE_MODULES)
	tar -C $(DEVICE_SRC) -cavf $(DEVICE_TAR) --exclude preinstalled --exclude preinstalled.tar.gz --xform s:'./':: .

$(LINUX_SRC):
	@git clone --depth=1 $(LINUX_REPO) -b $(LINUX_BRANCH)

$(DEVICE_SRC):
	mkdir -p $(DEVICE_SRC)

$(DEVICE_SRC)/preinstalled.tar.gz: | $(DEVICE_SRC)
	@wget $(DEVICE_PREINSTALLED) -O $@

$(DEVICE_SRC)/preinstalled/initrd.img: $(DEVICE_SRC)/preinstalled.tar.gz
	mkdir -p $(DEVICE_SRC)/preinstalled
	rm -rf $(DEVICE_SRC)/preinstalled/*
	@tar xzvf $< -C $(DEVICE_SRC)/preinstalled --wildcards 'system/boot/initrd.img-*'
	cp $(DEVICE_SRC)/preinstalled/system/boot/initrd.img-* $@

.PHONY: all clean distclean kernel uinitrd device