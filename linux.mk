include common.mk

CC := /usr/bin/arm-linux-gnueabihf-

all: $(LINUX_UIMAGE) $(LINUX_DTB) modules

clean:
	if test -d "$(LINUX_SRC)" ; then $(MAKE) -C $(LINUX_SRC) clean ; fi

distclean:
	rm -rf $(wildcard $(LINUX_SRC))

config: $(LINUX_SRC)
	$(MAKE) ARCH=arm CROSS_COMPILE=${CC} -C $(LINUX_SRC) odroidc_defconfig

uImage: config
	$(MAKE) ARCH=arm CROSS_COMPILE=${CC} -C $(LINUX_SRC) -j$(CPUS)
	$(MAKE) ARCH=arm CROSS_COMPILE=${CC} -C $(LINUX_SRC) -j$(CPUS) uImage

modules: config
	$(MAKE) ARCH=arm CROSS_COMPILE=${CC} -C $(LINUX_SRC) -j$(CPUS) uImage

$(LINUX_UIMAGE): uImage
	touch $@

$(LINUX_DTB): uImage
	touch $@

$(LINUX_SRC):
	git clone --depth=1 $(LINUX_REPO) -b $(LINUX_BRANCH)

.PHONY: all clean distclean config uImage modules