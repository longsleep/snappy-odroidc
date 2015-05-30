include common.mk

CC := /usr/bin/arm-linux-gnueabihf-

all: build

clean:
	if test -d "$(UBOOT_SRC)" ; then $(MAKE) -C $(UBOOT_SRC) clean ; fi

distclean:
	rm -rf $(wildcard $(UBOOT_SRC))

build: $(UBOOT_BIN)

$(UBOOT_BIN): $(UBOOT_SRC)
	$(MAKE) CROSS_COMPILE=${CC} -C $(UBOOT_SRC) odroidc_config
	$(MAKE) CROSS_COMPILE=${CC} -C $(UBOOT_SRC)
	touch $@

$(UBOOT_SRC):
	git clone --depth=1 $(UBOOT_REPO) -b $(UBOOT_BRANCH)

.PHONY: all clean distclean build

