#!/bin/bash

#[Script configuration]

#Sets the username for account creation
username="studerande"

#Sets the repository
repo="http://www.oapps.se/repo/chromebook"

#[Packages]
base="xorg-server xorg-xinit xorg-server-utils xf86-video-fbdev xf86-input-synaptics"
desktop="kdebase xfce4"
extra="wicd wicd-gtk chromium chromium-pepper-flash alsa-utils bash-completion sudo libwebkit libpng12 acpid pm-utils"


#Check internet connection

wget -q --tries=10 --timeout=20 -O - http://google.com > /dev/null
if [[ $? -eq 0 ]]; then
	echo "Internet connection appears to be working..."
	read -p "Press [enter] to continue with installation." KEY
else
	echo "No internet connection, please use 'wifi-menu mlan0' to connect to the internet, exiting now..."
	exit 1
fi  

#Download and install packages

echo "Updating system."

	pacman -Syyu $base --ignore systemd --ignore systemd-sysvcompat --noconfirm

echo "Installing additional software and configuration files."

	pacman -S $desktop $extra --noconfirm
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

#Cleanup
	
	rm -R *
	echo "Installation complete. System will restart in 10 seconds."
	sleep 10s; shutdown -r now

