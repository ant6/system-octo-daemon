#!/bin/bash

echo "test123" | passwd --stdin root

if [ $(echo $?) == 0 ]
then
	echo "Root password changed!"
else
	echo "Changing root passwd failed!"
fi

exit 0
