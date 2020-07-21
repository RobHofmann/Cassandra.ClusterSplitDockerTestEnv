#!/bin/bash

echo "Restarting all nodes (parallel old & new)"
for dc in \
    dcone \
    dctwo \
    dcthree \
; do
    for i in {1..7} \
    ; do
        oldnode="$dc""$i"
        newnode="$dc""9""$i"
        echo "Restarting $oldnode"
        docker restart $oldnode
        echo "Restarting $newnode"
        docker restart $newnode
        echo "Sleeping 1 minute"
        sleep 60
    done
done
echo "Done restarting all nodes"
