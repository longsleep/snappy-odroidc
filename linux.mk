include common.mk

CC := /usr/bin/arm-linux-gnueabihf-

all: build

clean:
	if test -d "$(LINUX_SRC)" ; then $(MAKE) -C $(LINUX_SRC) mrproper ; fi
	rm -f $(INITRD_IMG) $(LINUX_UIMAGE) $(LINUX_MODULES) $(LINUX_DTB)

distclean:
	rm -rf $(wildcard $(LINUX_SRC) $(INITRD_SRC))

$(LINUX_SRC):
	@git clone --depth=1 $(LINUX_REPO) -b $(LINUX_BRANCH)

$(LINUX_SRC)/.config: $(LINUX_SRC)
	$(MAKE) ARCH=arm CROSS_COMPILE=$(CC) -C $(LINUX_SRC) odroidc_defconfig

$(LINUX_UIMAGE): $(LINUX_SRC)/.config
	@rm -f $(LINUX_SRC)/arch/arm/boot/zImage
	@rm -f $(LINUX_UIMAGE)
	$(MAKE) ARCH=arm CROSS_COMPILE=$(CC) -C $(LINUX_SRC) -j$(CPUS) uImage

$(LINUX_DTB): $(LINUX_SRC)/.config
	$(MAKE) ARCH=arm CROSS_COMPILE=$(CC) -C $(LINUX_SRC) -j$(CPUS) dtbs

kernel: $(LINUX_UIMAGE)

dtb: $(LINUX_DTB)

modules: $(LINUX_SRC)/.config
	$(MAKE) ARCH=arm CROSS_COMPILE=$(CC) -C $(LINUX_SRC) -j$(CPUS) modules

linux: kernel dtb modules
	$(MAKE) ARCH=arm CROSS_COMPILE=$(CC) -C $(LINUX_SRC) -j$(CPUS) INSTALL_MOD_PATH=$(LINUX_MODULES) INSTALL_MOD_STRIP=1 modules_install

build: linux

.PHONY: kernel dtb modules linux build
