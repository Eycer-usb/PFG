#!/bin/bash
# Copy ssh keys
source environment.env
BASE_IP=159.90.9
START=3
END=19
USERNAME=ec

# for i in $(seq $START $END ); do
#     scp ~/ssh/* ec@${BASE_IP}.${i}:~/.ssh
# done

for i in $(seq  $START $END); do
    ssh-copy-id $USERNAME@${BASE_IP}.${i}
done
