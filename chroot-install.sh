#!/bin/bash

log() {
    printf "\n\033[32m$*\033[00m\n"
}

#[Script configuration]

#Sets the username for account creation
username="studerande"

#Sets the repository
repo="https://raw.githubusercontent.com/linuxichrome/chromebook/master"

#[Packages]
base="xorg-server xorg-xinit xorg-server-utils xf86-video-fbdev xf86-input-synaptics"
desktop="kdebase xfce4 xfce4-goodies"
extra="wicd wicd-gtk chromium chromium-pepper-flash alsa-utils bash-completion sudo libwebkit libpng12 acpid pm-utils libreoffice"
 
log "Installing packages and configution files."

	pacman -U /tmp/installpkg/* --noconfirm --needed
	ln -s /usr/share/zoneinfo/Europe/Stockholm /etc/localtime
	cp /root/tmp/config/50-touchpad.conf /etc/X11/xorg.conf.d
	cp /root/tmp/config/handler.sh /etc/acpi/
	cat /tmp/config/usbconf >> /etc/fstab
	mkdir /mnt/usbstick
	systemctl enable kdm
	systemctl enable wicd
	systemctl enable acpid

#Account creation

log "Creating user account. Please enter password: "

	useradd -m -g users -G wheel,storage,power -s /bin/bash $username
	passwd $username

#Download and install Citrix Reciever

log "Installing Citrix Receiver."
	 
	tar xf /tmp/linuxarmhf-13.tar.gz -C /tmp/citrix
	/tmp/citrix/setupwfc
	echo "application/x-ica=wfica.desktop" >> /usr/share/applications/mimeinfo.cache

#Finished
