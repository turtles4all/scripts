#!/bin/bash
while true
	do
	read -p "Which log would you like to backup? " LOG
		echo "Backing up $LOG"
		cp /var/log/$LOG.log /var/log/$LOG.bak
	read -p "Backup another log? (y/n) " RESPONSE
		[ "$RESPONSE" = "y" ] || break
done
