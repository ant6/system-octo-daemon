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
	shift
elif [ "$1" != "" ] && [ -d "/srv/mycontainer" ]
then
	# default location
	container_location="/srv/mycontainer"
	echo -e $print_ok "Container location set to: " $container_location
else
	echo -e $print_err "Wrong container location!"
	echo "use: $0 <container location> <package1 [package2 ...]>"
	exit 37
fi

# get packages to install
while [ $# -gt 0 ]
do
    packages="$packages $1"
    shift
done

yum -y --releasever=20 --nogpg --installroot=$container_location --disablerepo='*' --enablerepo=fedora install $packages

if [ $(echo $?) != 0 ]
then
	echo -e $print_err "Something went horribly wrong :|"
	exit 137
else
	echo -e $print_ok "Done installing:" $packages
fi
