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
    echo "Removing rfs"
    rm -rf busybox-1.24.1
fi

if [ $CLONE -eq 1 ]; then
    echo "Cloning rfs"
    curl -SLO https://busybox.net/downloads/busybox-1.24.1.tar.bz2
fi


cd busybox-1.24.1
make ARCH=arm CROSS_COMPILE=${CC} defconfig
make ARCH=arm CROSS_COMPILE=${CC} menuconfig 
# Busybox Settings -> Build Options -> Build Busybox as a static binary (no shared libs)

# Build the RFS
sudo make ARCH=arm CROSS_COMPILE=${CC} install CONFIG_PREFIX=../RFS -j12
# this will add bin, sbin, and usr

# TODO setup RFS
