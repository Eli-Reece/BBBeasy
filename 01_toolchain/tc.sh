#!/bin/bash

# exit on error
set -e

CLONE=0
REMOVE=0

while getopts "cr" opt; do
    case $opt in
        c)
            CLONE=1
            ;;
        r)
            REMOVE=1
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            ;;
    esac
done

# CLEANING
if [ $REMOVE -eq 1 ]; then
    echo "Removing toolchain"
    sudo rm -rfv /opt/gcc-6.4.1-arm-linux
    echo "Toolchain removed"
    # remove CC export if set
    if [[ -v CC ]]; then
        unset CC
    fi
    # show it worked
    echo "Printing CC"
    echo ${CC}
fi

# CLONING
if [ $CLONE -eq 1 ]; then
    echo "Cloning toolchain"
    # download the toolchain
    curl -SLO https://releases.linaro.org/components/toolchain/binaries/latest-6/arm-linux-gnueabihf/gcc-linaro-6.4.1-2017.11-x86_64_arm-linux-gnueabihf.tar.xz
    # extract the toolchain
    sudo tar -xvf gcc-linaro-6.4.1-2017.11-x86_64_arm-linux-gnueabihf.tar.xz -C /opt/ \
    --transform='s|gcc-linaro-6.4.1-2017.11-x86_64_arm-linux-gnueabihf|gcc-6.4.1-arm-linux|'
fi

# PREP
# TODO check if toolchain is installed at local path and extract and rename to prevent unnecessary downloads
if [ ! -d /opt/gcc-6.4.1-arm-linux ]; then
    echo "Toolchain not installed"
    exit 1
else
    echo "Prepping toolchain"
    echo "Exporting cross compiler variable"
    cd /opt/gcc-6.4.1-arm-linux
    export CC=${PWD}/bin/arm-linux-gnueabihf-
    # show it worked
    ${CC}gcc --version
fi






