# ODRDOID Snappy builder

Scripts to build [Ubuntu Snappy](http://developer.ubuntu.com/snappy/) OEM and device part for [ODROID C1](http://www.hardkernel.com/main/products/prdt_info.php?g_code=G141578608433).

## Requirements

To build all parts, a couple of dependencies are required. On Ubuntu you can
install all build dependencies with the following command.

```bash
sudo apt-get install build-essential u-boot-tools lzop debootstrap debootstrap gcc-arm-linux-gnueabihf
```

## Building

A `Makefile` is provided to build U-Boot, Kernel and Initrd from source. The
sources will be cloned into local folders if not there already. We currently
clone from Hardkernel official U-Boot and Linux ODROID C1 branches.

To build it all, just run `make`. This will produce a oem snap `odroidc_x.y_all.snap`
and a `device-odroidc.tar.gz` device part, which can be used to build your own
Ubuntu Snappy image for ODROID C1.

### Build OEM snap

You can build the OEM snap seperately too. The OEM snap contains the U-Boot,
so make sure you have build the U-Boot first with `make u-boot`.

```bash
make oem
```

### Build device part

Of course the device part can be built seperately as well. The device part
contains the Linux kernel and modules, so make sure to have built the Linux
Kernel first with `make linux`.

```bash
make device
```

## Build Snappy image for ODROID C1

Make sure you have build the OEM snap and the device part first. Then you can
simply create the image like this.

```bash
sudo ubuntu-device-flash core 15.04 \
	--oem odroidc_x.y_all.snap \
	--device-part device-odroidc.tar.xz \
	--developer-mode \
	-s 3 \
	-o odroidc.img
```

Flash this to SD or eMMC and your ODROID will boot into Snappy. Default user
is `ubuntu` with password `ubuntu`.

Enjoy!

--
Simon Eisenmann <simon@longsleep.org>