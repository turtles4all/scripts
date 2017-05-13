#!/bin/bash
A=$(md5sum /etc/shadow)    ##echo $A
B=$(md5sum /etc/passwd)	   ##echo $B 
if [ $A -eq $B ]; then
	echo "the PASSWD and SHADOW file hashes ARE the same"
else
	echo "the PASSWD and SHADOW file hashes ARE NOT the same" 
fi 2>/dev/null
 
