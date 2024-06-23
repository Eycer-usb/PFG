#!/bin/bash
source environment.env
IP_START=159.90.9
START=3
END=19
USERNAME=ec

for i in $(seq $START $END); do
    echo $PASSWD | ssh -tt $USERNAME@${IP_START}.${i} "sudo init 6"
done

