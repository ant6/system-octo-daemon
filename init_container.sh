#!/bin/bash

container_location="/srv/mycontainer"

# Gathering system info 

# check for root privileges
if [ "$(whoami)" != "root" ]; then
	echo "Sorry, you are not root."
	exit 1
fi

arch=$(uname -m)
kernel=$(uname -r)
if [ -f /etc/lsb-release ]; then
        os=$(lsb_release -s -d)
elif [ -f /etc/debian_version ]; then
        os="Debian $(cat /etc/debian_version)"
elif [ -f /etc/redhat-release ]; then
        os=`cat /etc/redhat-release`
else
        os="$(uname -s) $(uname -r)"
fi

# Printing system info 

echo "Detected:" $os
echo "         " $arch
echo "         " $kernel
echo "-------------------------------"

# Creating container for Fedora
if [[ $os == *"Fedora"* ]]
then

	echo "Creating a Fedora container tree in a subdirectory"

	# Do something useful here...

	yum -y --releasever=20 --nogpg --installroot=$container_location --disablerepo='*' --enablerepo=fedora install systemd passwd yum fedora-release vim-minimal

	if [ $(echo $?) == 0 ]
	then
		echo "Great success - Fedora minimal created!"
		echo "Entering container!"
		systemd-nspawn -D $container_location
		# run something?
	fi


#elif [[ $os == *"Arch"* ]]
else
	echo "Not yet implemented"
fi
