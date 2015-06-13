#!/bin/bash

print_err='[\e[1;31mERROR\e[0m] '

# check for root privileges
if [ "$(whoami)" != "root" ]; then
	echo -e $print_err "Sorry, you are not root."
	exit 1
fi

systemctl list-machines
