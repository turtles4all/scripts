@echo off

echo "Account information:" > enum.txt
echo "users:" >>enum.txt
net user >> enum.txt
whoami /all >> enum.txt
echo "current user" >> enum.txt
whoami >> enum.txt
echo "Logged in users:"
query user >> enum.txt
echo "Default Account settings:"
net accounts >> enum.txt
echo "Domain" 
systeminfo | findstr /B /C:"Domain" >> enum.txt
echo "User Privs:"
whoami /priv >> enum.txt
echo "System Info" >> enum.txt
ehco "Version:" >> enum.txt
ver >> enum.txt

systeminfo >> enum.txt

running

ipconfig /desplaydns

Account:
accounts / groups
looged in users
domains
permissions

System:
Hostname
OS version
OS Patches

shed tasks
startup
running process tasklist
services  sc query 
printers 
installed software
security settings
registry

networking:
ARP cache
networking connections
open ports
network config
DNS Cache

FileSystem:
Partitions
network shares

Logs:
security