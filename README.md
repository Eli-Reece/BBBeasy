# Easy BBB build
## Environment
### OS/Kernel
- EndeavourOS Linux x86_64
- 6.8.2-arch1-1
### Packages I didn't already have
- bc
- uboot-tools (to get mkimage)
### Hardware
- BBB Rev C
- FT232 usb to serial
- SD card (128GB), only need like 2GB
- Power Supply (5V, 2A)
## SD Card
- Before running kernel.sh you should have an sd-card prepped and mounted

### Using fdisk
> sudo fdisk /dev/sdb
- delete all of the partitions
- create a new partition with +50MB for the last sector
- create a new partition with +1000MB for the last sector
- Change the partition types
> sudo mkfs.fat -F 32 -n BOOT /dev/sdb1

> sudo mkfs.ext3 -L RFS /dev/sdb2
- verify by running
> sudo blkid /dev/sdb*
- I then mounted both partitions to /mnt/sdb1 & /mnt/sdb2
