#!/bin/bash

pingCount=6

getGateway (){
	ip route show default | awk '/default/ {print $3}'
}
getPingPath (){
	which ping
}
doPing (){
	$pingPath -c $pingCount -W 1 $gateway
	return $?
}

gateway=$(getGateway)

pingPath=$(getPingPath)

echo pinging $gateway

doPing

if [[ $? = '0' ]]; then
	echo Positive;
else
	echo Negative;
fi



