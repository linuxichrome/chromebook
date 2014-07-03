#!/bin/bash
repo="https://raw.githubusercontent.com/linuxichrome/chromebook/master"

log() {
    printf "\n\033[32m$*\033[00m\n"
}

EMMC="/dev/mmcblk0"
DEFAULT_USB="/dev/sda"
DEVICE=${1:-$DEFAULT_USB}
INSTALLFILES="/root/installfiles"
INSTALLPKG="/root/installpkg"

if [ "$DEVICE" = "$EMMC" ]; then
    P1="${DEVICE}p1"
    P2="${DEVICE}p2"
    P3="${DEVICE}p3"
    P12="${DEVICE}p12"
else
    P1="${DEVICE}1"
    P2="${DEVICE}2"
    P3="${DEVICE}3"
    P12="${DEVICE}12"
fi

OSHOST="http://archlinuxarm.org/os/"
OSFILE="ArchLinuxARM-chromebook-latest.tar.gz"
UBOOTHOST="http://commondatastorage.googleapis.com/chromeos-localmirror/distfiles/"
UBOOTFILE="nv_uboot-snow.kpart.bz2"

if [ $DEVICE = $EMMC ]; then
    # for eMMC we need to get some things before we can partition
    
	if [ -d "$INSTALLFILES" ]; then
		pacman -U ~/installfiles/* --needed --noconfirm
	else
		printf "Mappen installfiles existerar inte, avslutar..."
		exit 1
	fi    
fi

log "Skapar volymer på ${DEVICE}"
umount ${DEVICE}*
parted -s ${DEVICE} mklabel gpt
cgpt create -z ${DEVICE}
cgpt create ${DEVICE}
cgpt add -i 1 -t kernel -b 8192 -s 32768 -l U-Boot -S 1 -T 5 -P 10 ${DEVICE}
cgpt add -i 2 -t data -b 40960 -s 32768 -l Kernel ${DEVICE}
cgpt add -i 12 -t data -b 73728 -s 32768 -l Script ${DEVICE}
PARTSIZE=`cgpt show ${DEVICE} | grep 'Sec GPT table' | egrep -o '[0-9]+' | head -n 1`
cgpt add -i 3 -t data -b 106496 -s `expr ${PARTSIZE} - 106496` -l Root ${DEVICE}
partprobe ${DEVICE}
mkfs.ext2 -F $P2
mkfs.ext4 -F $P3
mkfs.vfat -F 16 $P12

cp /root/src/* /tmp

cd /tmp

if [ ! -f "${OSFILE}" ]; then
    log "${OSFILE} existerar inte, avslutar..."
    exit 1
fi

log "Installerar Arch på ${P3} (detta kommer ta en stund...)"

cp /root/src/* /tmp

mkdir -p root

mount $P3 root
tar -xf ${OSFILE} -C root

mkdir -p mnt

mount $P2 mnt
cp root/boot/vmlinux.uimg mnt
umount mnt

mount $P12 mnt
mkdir -p mnt/u-boot
cp root/boot/boot.scr.uimg mnt/u-boot
umount mnt

if [ $DEVICE != $EMMC ]; then
    log "Copying over devkeys (to generate kernel later)"
    mkdir -p /tmp/root/usr/share/vboot/devkeys
    cp -r /usr/share/vboot/devkeys/ /tmp/root/usr/share/vboot/
fi

if [ $DEVICE = $EMMC ]; then
    echo "root=${P3} rootwait rw quiet lsm.module_locking=0" >config.txt

    vbutil_kernel \
    --pack arch-eMMC.kpart \
    --keyblock /usr/share/vboot/devkeys/kernel.keyblock \
    --signprivate /usr/share/vboot/devkeys/kernel_data_key.vbprivk \
    --config config.txt \
    --vmlinuz /boot/vmlinux.uimg \
    --arch arm \
    --version 1

    dd if=arch-eMMC.kpart of=$P1
else
    if [ ! -f "${UBOOTFILE}" ]; then
        log "Downloading ${UBOOTFILE}"
        wget ${UBOOTHOST}${UBOOTFILE}
    else
        log "Looks like you already have ${UBOOTFILE}"
    fi
    bunzip2 -f ${UBOOTFILE}
    dd if=nv_uboot-snow.kpart of=$P1
    log "All done! Reboot and press ctrl + U to boot Arch"
fi

if [ $DEVICE = $EMMC ]; then
#Check if installpkg directory exists so we can install packages to the new installation
	if [ -d "$INSTALLPKG" ]; then
		log "Kopierar filer (detta kommer ta en stund...)"	
		sh /root/scripts/chroot.sh
		cp -R $INSTALLPKG /mnt/arch/tmp/installpkg
		cp -R /root/citrix /mnt/arch/tmp/citrix
		cp -R /root/config /mnt/arch/tmp/config
		cp /root/scripts/chroot-install.sh /mnt/arch/tmp
		chroot /mnt/arch /bin/bash -c "sh /tmp/chroot-install.sh"
	fi
log "All done! Reboot and press ctrl + D to boot Arch"
fi
	printf "System will restart in 10 seconds."
	sleep 10s; shutdown -r now
sync

