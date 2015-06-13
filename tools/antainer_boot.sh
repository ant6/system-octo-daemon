#!/bin/bash

# this script installs additional software in given container

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
elif [ "$1" == "" ] && [ -d "/srv/mycontainer" ]
then
	# default location
	container_location="/srv/mycontainer"
	echo -e $print_ok "Container location set to: " $container_location
else
	echo -e $print_err "Wrong container location!"
	echo "use: $0 <container location>"
	exit 37
fi

# "boot" the container
systemd-nspawn -bD $container_location
