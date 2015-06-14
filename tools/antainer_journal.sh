#!/bin/bash

print_err='[\e[1;31mERROR\e[0m] '

# check for root privileges
if [ "$(whoami)" != "root" ]; then
	echo -e $print_err "Sorry, you are not root."
	exit 1
fi

if [ "$1" != "" ]
then
	journalctl -M $1
else
	echo -e $print_err "Wrong or not given machine name!"
	exit 37
fi
