#!/bin/bash
if [ $1 ]; then filename=$1
else filename=NMAP_all_hosts.txt
fi
IFS=$'\r\n' GLOBIGNORE='*' command eval  'NMAPfile=$(cat $filename)'
IFS=$'\r\n' GLOBIGNORE='*' command eval  "SERVS=($(echo "$NMAPfile" | grep -E tcp.*open | awk '{print $NF}' | sort -n | uniq ))"
IFS=$'\r\n' GLOBIGNORE='*' command eval  "IPS=($(echo "$NMAPfile" | grep -E 'Nmap scan report' | awk '{print $NF}'))"
iplen=${#IPS[@]}
for x in ${SERVS[@]}; do
    #Uncomment to count IP's in service
    #y=0
    printf "\n%s\n===============\n" "$x"
    for ((i=0; i != $iplen; i++));do
	    echo "$NMAPfile" | sed -n -e "/Nmap scan report for ${IPS[$i]}/,/Nmap scan/ p" |
	    grep -E "open.* $x$" 1>/dev/null
	    if [[ $? -eq 0 ]];then
		    echo ${IPS[$i]}
   		    #Uncomment to count IP's in service
		    #((y++))
	    fi
    done
    #Uncomment to count IP's in service
    #echo $y 
done
