#!/bin/bash

#Create mount dirs and mount the system

	mkdir /mnt/arch
	mount /dev/mmcblk0p3 /mnt/arch
	mount /dev/mmcblk0p2 /mnt/arch/boot

#Mount api filesystems

	cd /mnt/arch
	mount -t proc proc proc/
	mount --rbind /sys sys/
	mount --rbind /dev dev/

#Copy resolv.conf to make sure internet is working

	cp /etc/resolv.conf /mnt/arch/etc/resolv.conf

#Enter chroot bash shell

	chroot /mnt/arch /bin/bash
