#!/bin/bash

log() {
    printf "\n\033[32m$*\033[00m\n"
}

#[Script configuration]

#Sets the username for account creation
USERNAME="studerande"

CONFIG="/tmp/config"

#[Packages]
#base="xorg-server xorg-xinit xorg-server-utils xf86-video-fbdev xf86-input-synaptics"
#desktop="kdebase xfce4 xfce4-goodies"
#extra="wicd wicd-gtk chromium chromium-pepper-flash alsa-utils bash-completion sudo libwebkit libpng12 acpid pm-utils libreoffice"
 
log "Installerar program och konfigurationsfiler (Ta en kaffe under tiden...)"

	pacman -U /tmp/installpkg/* --noconfirm --needed
	ln -s /usr/share/zoneinfo/Europe/Stockholm /etc/localtime
	cp $CONFIG/50-touchpad.conf /etc/X11/xorg.conf.d
	cp $CONFIG/handler.sh /etc/acpi
	cp $CONFIG/manager-settings.conf /etc/wicd
	cat $CONFIG/usbconf >> /etc/fstab
	mkdir /mnt/usbstick
	systemctl enable kdm
	systemctl enable wicd
	systemctl enable acpid

log "Ange lösenord för $USERNAME:"

	useradd -m -g users -G wheel,storage,power -s /bin/bash $USERNAME
	passwd $USERNAME

#Extrahera och installera citrix

log "Installerar Citrix."
	 
	tar xf /tmp/citrix/linuxarmhf-13.tar.gz -C /tmp/citrix
	/tmp/citrix/setupwfc
	echo "application/x-ica=wfica.desktop" >> /usr/share/applications/mimeinfo.cache

#Finished
