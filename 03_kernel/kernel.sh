#!/bin/bash

# exit on error
set -e

REMOVE=0
CLONE=0

while getopts "rcp" opt; do
    case $opt in
        r)
            REMOVE=1
            ;;
        c)
            CLONE=1
            ;;

        \?)
        echo "Invalid option: -$OPTARG" >&2
        ;;
    esac
done

if [ $REMOVE -eq 1 ]; then
    echo "Removing kernel"
    rm -rf linux
fi

if [ $CLONE -eq 1 ]; then
    echo "Cloning linux kernel"
    git clone https://github.com/beagleboard/linux.git
fi

# prep and build
# TODO get project root environment variable for quick paths
# 6-core processor so -j12
sudo make ARCH=arm CROSS_COMPILE=${CC} omap2plus_defconfig -j12
sudo make ARCH=arm CROSS_COMPILE=${CC} uImage dtbs LOADADDR=0x80008000 -j12
sudo make ARCH=arm CROSS_COMPILE=${CC} modules -j12

# copy uImage and dtbs to image dir
cp arch/arm/boot/uImage arch/arm/boot/dts/ti/omap/am335x-boneblack.dtb ../images

# navigate to images directory
cd ../images

# check if uEnv.txt exists, if not create and write to it
if [ ! -f uEnv.txt ]; then
    touch uEnv.txt
    echo "console=ttyS0,115200n8" >> uEnv.txt
    echo "netargs=setenv bootargs console=ttyO0,115200n8 root=/dev/mmcblk0p2 ro rootfstype=ext4 rootwait debug earlyprintk mem=512M" >> uEnv.txt
    echo "netboot=echo Booting from microSD ...; setenv autoload no ; load mmc 0:1 ${loadaddr} uImage ; load mmc 0:1 ${fdtaddr} am335x-boneblack.dtb ; run netargs ; bootm ${loadaddr} - ${fdtaddr}" >> uEnv.txt
    echo "uenvcmd=run netboot" >> uEnv.txt
fi

# copy images to mounted boot partition of SD card
sudo cp * /mnt/sdb1


