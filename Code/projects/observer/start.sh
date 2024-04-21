#!/bin/bash
while [ 1 ]
do
# Importing environment variables
export $(grep -v '^#' environment.env | xargs -0)

# Compile
make all

# run 
chmod +x julietX
gnome-terminal -- bash -c "sudo -E ./julietX"

export SOCKET_PORT=43319
export COLLECTOR_ENDPOINT="192.168.2.102:43317/api/v1/server-metrics/add"
sudo -E ./julietX

done
