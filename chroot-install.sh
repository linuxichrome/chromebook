#!/bin/bash

log() {
    printf "\n\033[32m$*\033[00m\n"
}

#[Script configuration]

#Sets the username for account creation
USERNAME="studerande"

CONFIG="/tmp/config"
XORGCONF="/etc/X11/xorg.conf.d"

#[Packages]
#base="xorg-server xorg-xinit xorg-server-utils xf86-video-fbdev xf86-input-synaptics"
#desktop="kdebase xfce4 xfce4-goodies"
#extra="wicd wicd-gtk chromium chromium-pepper-flash alsa-utils bash-completion sudo libwebkit libpng12 acpid pm-utils libreoffice"
 
log "Installerar program och konfigurationsfiler (Ta en kaffe under tiden...)"

	pacman -U /tmp/installpkg/* --noconfirm --needed
	cp $CONFIG/50-touchpad.conf $XORGCONF
	cp $CONFIG/00-keyboard.conf $XORGCONF
	cp $CONFIG/10-evdev.conf $XORGCONF
	cp $CONFIG/handler.sh /etc/acpi
	#Wifi settings
	cp $CONFIG/manager-settings.conf /etc/wicd
	cp $CONFIG/wireless-settings.conf /etc/wicd
	#Set usb mount point
	cat $CONFIG/usbconf >> /etc/fstab
	mkdir /mnt/usbstick
	
	#Enable services
	systemctl enable kdm
	systemctl enable wicd
	systemctl enable acpid

	#Set locale
	localectl set-locale LANG="sv_SE.UTF-8"
	ln -s /usr/share/zoneinfo/Europe/Stockholm /etc/localtime

log "Ange lösenord för $USERNAME:"

	useradd -m -g users -G wheel,storage,power -s /bin/bash $USERNAME
	passwd $USERNAME
	echo "$USERNAME ALL=(ALL:ALL) ALL" >> /etc/sudoers
#Extrahera och installera citrix

log "Installerar Citrix."
	 
	tar xf /tmp/citrix/linuxarmhf-13.tar.gz -C /tmp/citrix
	/tmp/citrix/setupwfc
	echo "application/x-ica=wfica.desktop" >> /usr/share/applications/mimeinfo.cache

#Finished
