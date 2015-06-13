CPUS := $(shell getconf _NPROCESSORS_ONLN)

OUTPUT_DIR := $(PWD)

UBOOT_REPO := https://github.com/longsleep/u-boot-odroidc.git
UBOOT_BRANCH := master
UBOOT_SRC := $(PWD)/u-boot
UBOOT_BIN := $(UBOOT_SRC)/sd_fuse/u-boot.bin

LINUX_REPO := https://github.com/longsleep/ubuntu-odroidc.git
LINUX_BRANCH := master
LINUX_SRC := $(PWD)/linux
LINUX_UIMAGE := $(LINUX_SRC)/arch/arm/boot/uImage
LINUX_DTB := $(LINUX_SRC)/arch/arm/boot/dts/meson8b_odroidc.dtb
LINUX_MODULES := $(LINUX_SRC)/modules

DEVICE_SRC := $(PWD)/device
DEVICE_TAR := $(PWD)/device-odroidc.tar.xz
