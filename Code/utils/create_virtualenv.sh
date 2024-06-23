#!/bin/bash
source environment.env
IP_START=159.90.9
START=3
END=19
USERNAME=ec

for i in $(seq $START $END); do
    echo $PASSWD | ssh -tt $USERNAME@${IP_START}.${i} "sudo apt install -y python3\
                                                            python3-virtualenv\
                                                            libpq-dev;\
                                                        cd PFG/Code;
                                                        python3 -m virtualenv env;
                                                        source env/bin/activate;\
                                                        pip3 install -r requirements.txt"

done