#!/bin/bash
STATUS=$(service sshd status | grep 'Active' | awk '{print $2 $3}')
if [ $STATUS != 'active(running)' ]; then
	service sshd restart
fi
