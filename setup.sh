#!/bin/bash

#Load keymap

loadkeys sv-latin1

#Connect to wireless network

wifi-menu mlan0

#Test internet connection

wget -q --tries=10 --timeout=20 -O - http://google.com > /dev/null
if [[ $? -eq 0 ]]; then
	echo "Internet connection confirmed"
	read -p "Press [enter] to continue with installation." KEY
else
	echo "No internet connection, will try to reconnect in 5 seconds"
	sleep 5s; sh setup.sh
fi

#Install Arch Linux to eMMC

	sh install.sh /dev/mmcblk0
