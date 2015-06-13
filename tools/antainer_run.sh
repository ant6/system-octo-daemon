#!/bin/bash

# this script runs given command in container

print_ok='[\e[1;32m  OK  \e[0m] '
print_err='[\e[1;31mERROR\e[0m] '

# check for root privileges
if [ "$(whoami)" != "root" ]; then
	echo -e $print_err "Sorry, you are not root."
	exit 1
fi

# get container location
if [ -d $1 ] && [ "$1" != "" ]
then
	container_location=$1
	echo -e $print_ok "Container location set to: " $1
	shift
elif [ "$1" != "" ] && [ -d "/srv/mycontainer" ]
then
	# default location
	container_location="/srv/mycontainer"
	echo -e $print_ok "Container location set to: " $container_location
elif [ "$1" == "" ]
then
	echo -e $print_err "Wrong container location or lack of command to run!"
	echo "use: $0 <container location> <command>"
	exit 37
fi

command=$1

echo -e $print_ok "Checking if:" $command "is installed in container"
yum -y --nogpg --installroot=$container_location list installed $command
if [ $(echo $?) == 0 ]
then
	echo "Running:" $command "in container"
	systemd-nspawn -D $container_location $command
else
	echo -e $print_err "Command:" $command "is not installed in container"
	echo -n "Try to install package" $command "(y)? Or maybe just run int anyway(r)? [y/r/n]: "
	read ins
	if [ "$ins" == "y" ]
	then
		yum -y --releasever=20 --nogpg --installroot=$container_location --disablerepo='*' --enablerepo=fedora install $command
	elif [ "$ins" == "r" ]
	then
		systemd-nspawn -D $container_location $command
	else
		echo -e $print_err "Quiting!"
		exit 37
	fi
fi
