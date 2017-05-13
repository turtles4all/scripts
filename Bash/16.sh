#!/bin/bash
for x in $(seq 1 50); do
	nc -nvz -w 1 10.0.0.$x 22;
done 2>&1


