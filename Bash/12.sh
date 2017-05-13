#!/bin/bash
if [ -e /etc/machine-id ] ; then
	id=$(cat /etc/machine-id)
	echo $id located in /etc/
elif [ -e /var/lib/dbus/machine-id ] ; then
	id=$(cat /var/lib/dbus/machine-id)
	echo $id located in /var/lib/dbus/
else
	echo "This system is NOT Linux"
fi

