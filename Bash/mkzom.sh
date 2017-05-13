#/bin/bash
((sleep 1 & sleep 1 & sleep 1 & exec sleep 30) &) &
