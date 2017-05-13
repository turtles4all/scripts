#!/bin/bash
if [ -e /var/log/auth.log ] ; then
	cp /var/log/auth.log /var/log/auth.log.bak
	echo "/var/log backed up!"
fi

