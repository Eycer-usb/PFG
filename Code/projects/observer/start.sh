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
sudo -E ./julietX

done
