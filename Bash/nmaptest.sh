#!/bin/bash 
IFS=$'\r\n' GLOBIGNORE='*' command eval  "SERVS=($(cat NMAP_all_hosts.txt | grep -E tcp.*open | awk '{print $NF}' | sort -n | uniq))"
IFS=$'\r\n' GLOBIGNORE='*' command eval  "IPS=($(cat NMAP_all_hosts.txt | grep -E 'Nmap scan report' | awk '{print $NF}'))"
iplen=${#IPS[@]}
for x in ${SERVS[@]}; do
    printf "%s\n===========\n" "$x"
    for ((i=0; i != $iplen; i++));do
	    content=$(sed -n -e "/${IPS[$i]}/,/${IPS[$i+1]}/ p" NMAP_all_hosts.txt)
	    echo "$content"
	    read -p "awsdc"
	    if [[ $content == *$x* ]];then
		    echo ${IPS[$i]}
	    fi
    done
done
