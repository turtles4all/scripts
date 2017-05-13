#!/bin/bash
if [ -e /etc/machine-id ] ;
then
	id=$(cat /etc/machine-id)
elif [ -e /var/lib/dbus/machine-id ] ;
then
	id=$(cat /var/lib/dbus/machine-id)
else
	echo "This system has no Unique Machine-ID"
fi
touch Profile-${id}.txt
echo Profile -${id}.txt

