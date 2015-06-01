CPUS := $(shell getconf _NPROCESSORS_ONLN)

OUTPUT_DIR := $(PWD)

UBOOT_REPO := https://github.com/hardkernel/u-boot.git
UBOOT_BRANCH := odroidc-v2011.03
UBOOT_SRC := $(PWD)/u-boot
UBOOT_BIN := $(UBOOT_SRC)/sd_fuse/u-boot.bin

LINUX_REPO := https://github.com/hardkernel/linux.git
LINUX_BRANCH := odroidc-3.10.y
LINUX_SRC := $(PWD)/linux

DEVICE_SRC := $(PWD)/device
DEVICE_TAR := $(PWD)/device-odroidc.tar.xz

INITRD_IMG := $(PWD)/initrd.img
INITRD_SRC := $(PWD)/initrd
