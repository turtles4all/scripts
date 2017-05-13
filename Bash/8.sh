#!/bin/bash
A=1
B=Weeeeeeeeeeee
while [ $A != 0 ]; do
	echo $B
let A=$A-1
echo $?
done

