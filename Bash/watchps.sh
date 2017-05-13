#!/bin/bash
mkfifo fifo
ps -elf | grep -v 'ps\|sleep\|diff' > fifo &
while true; do
ps -elf | grep -v 'ps\|sleep\|diff' | diff /dev/stdin fifo
ps -elf | grep -v 'ps\|sleep\|diff' > fifo &
sleep 2
done
