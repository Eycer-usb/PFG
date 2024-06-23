#!/bin/bash
source environment.env
BASE_IP=159.90.9
START=3
END=19
USERNAME=ec

for i in $(seq $START $END); do
    echo $PASSWD | ssh -tt $USERNAME@${BASE_IP}.${i} "sudo apt install -y git"
    ssh $USERNAME@${BASE_IP}.${i} "git clone git@github.com:Eycer-usb/PFG.git"
done