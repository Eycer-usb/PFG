#!/bin/bash
source environment.env
IP_START=159.90.9
START=3
END=19
USERNAME=ec

scp ./config_pic.json $USERNAME@${IP_START}.6:~/PFG/Code/config.json
scp ./config_pic.json $USERNAME@${IP_START}.10:~/PFG/Code/config.json