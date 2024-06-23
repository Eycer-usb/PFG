#!/bin/bash
source environment.env
BASE_IP=159.90.9
START=3
END=19
USERNAME=ec

for i in $(seq $START $END); do
    ssh $USERNAME@${BASE_IP}.${i} "cd PFG/; git reset --hard"
    ssh $USERNAME@${BASE_IP}.${i} "cd PFG/; git checkout logs"
    ssh $USERNAME@${BASE_IP}.${i} "cd PFG/; git pull"
done