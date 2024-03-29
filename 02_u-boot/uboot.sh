#!/bin/bash

# exit on error
set -e

REMOVE=0
CLONE=0
PREP=0

while getopts "rcp" opt; do
    case $opt in
        r)
            REMOVE=1
            ;;
        c)
            CLONE=1
            ;;
        p)
            echo "Prep and Patching u-boot"
            cd u-boot
            git checkout v2018.11
            git apply ~/u-boot.patch
            ;;
        \?)
        echo "Invalid option: -$OPTARG" >&2
        ;;
    esac
done

if [ $REMOVE -eq 1 ]; then
    echo "Removing u-boot"
    rm -rf u-boot
fi

if [ $CLONE -eq 1 ]; then
    echo "Cloning u-boot"
    git clone git://git.denx.de/u-boot.git u-boot/
fi

if [ $PREP -eq 1 ]; then
    cd u-boot/
    git checkout v2018.01
    make clean
    make ARCH=arm CROSS_COMPILE=${CC} am335x_boneblack_defconfig
    make ARCH=arm CROSS_COMPILE=${CC}
fi 

# copy MLO and u-boot.img to image dir
cp MLO u-boot.img ../images