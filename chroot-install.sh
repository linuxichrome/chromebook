#!/bin/bash

#[Script configuration]

#Sets the username for account creation
username="studerande"

#Sets the repository
repo="https://raw.githubusercontent.com/linuxichrome/chromebook/master"

#[Packages]
base="xorg-server xorg-xinit xorg-server-utils xf86-video-fbdev xf86-input-synaptics"
desktop="kdebase xfce4 xfce4-goodies"
extra="wicd wicd-gtk chromium chromium-pepper-flash alsa-utils bash-completion sudo libwebkit libpng12 acpid pm-utils libreoffice"
 
echo "Updating system."

	pacman -Syy --ignore systemd --ignore systemd-sysvcompat --noconfirm

echo "Installing additional software and configuration files."

	pacman -U /installpkg/* --noconfirm
	ln -s /usr/share/zoneinfo/Europe/Stockholm /etc/localtime
	wget -P /etc/X11/xorg.conf.d $repo/50-touchpad.conf
	wget $repo/handler.sh -O /etc/acpi/handler.sh
	wget $repo/usbconf
	cat usbconf >> /etc/fstab
	mkdir /mnt/usbstick
	systemctl enable kdm
	systemctl enable wicd
	systemctl enable acpid

#Account creation

echo "Creating user accounts."

	useradd -m -g users -G wheel,storage,power -s /bin/bash $username
	passwd $username

#Download and install Citrix Reciever

echo "Installing Citrix Receiver."
	
	wget -P /tmp $repo/linuxarmhf-13.tar.gz 
	mkdir /tmp/ctxinstall
	tar -xzvf /tmp/linuxarmhf-13.tar.gz -C /tmp/ctxinstall 
	/tmp/ctxinstall/setupwfc
	rm -R /tmp/ctxinstall
	rm /tmp/linuxarmhf-13.tar.gz
	echo "application/x-ica=wfica.desktop" >> /usr/share/applications/mimeinfo.cache

#Finished
	
	echo "Installation complete. System will restart in 10 seconds."
	sleep 10s; shutdown -r now

