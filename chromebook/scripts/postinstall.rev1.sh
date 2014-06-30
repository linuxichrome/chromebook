#!/bin/bash

#[Settings]

#Sets the username for account creation
username="studerande"

#Sets the repository
repo="http://www.oapps.se/repo/chromebook"

#Check internet connection

wget -q --tries=10 --timeout=20 -O - http://google.com > /dev/null
if [[ $? -eq 0 ]]; then
	echo "Internet connection appears to be working..."
	read -p "Press [enter] to continue with installation." KEY
else
	echo "No internet connection, please use 'wifi-menu mlan0' to connect to the internet, exiting now..."
	exit 1
fi  

#Download and install applications

echo "Updating system."

	pacman -Syyu --ignore systemd --ignore systemd-sysvcompat

echo "Installing desktop environment."

	pacman -S xorg-server xorg-xinit xorg-server-utils xorg-twm xorg-xclock xterm xf86-video-fbdev --noconfirm
	pacman -S kdebase xfce4 --noconfirm

echo "Installing additional software and configuration files."

	pacman -S xf86-input-synaptics sudo bash-completion chromium chromium-pepper-flash alsa-utils libwebkit wicd wicd-gtk libpng12 acpid pm-utils --noconfirm
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
	wget -P /home/studerande $repo/linuxarmhf-13.tar.gz 
	mkdir /home/studerande/Citrix
	tar -xzvf /home/studerande/linuxarmhf-13.tar.gz -C /home/studerande/Citrix/ 
	/home/studerande/Citrix/setupwfc
	rm -R /home/studerande/Citrix
	rm /home/studerande/linuxarmhf-13.tar.gz
	echo "application/x-ica=wfica.desktop" >> /usr/share/applications/mimeinfo.cache

#Cleanup
	
	rm *
	
