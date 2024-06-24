#!/bin/bash
source environment.env
IP_START=159.90.9
USERNAME=ec

scp ./config_pb.json $USERNAME@${IP_START}.3:~/PFG/Code/config.json
scp ./config_pb.json $USERNAME@${IP_START}.7:~/PFG/Code/config.json

scp ./config_pi.json $USERNAME@${IP_START}.4:~/PFG/Code/config.json
scp ./config_pi.json $USERNAME@${IP_START}.8:~/PFG/Code/config.json

scp ./config_pc.json $USERNAME@${IP_START}.5:~/PFG/Code/config.json
scp ./config_pc.json $USERNAME@${IP_START}.9:~/PFG/Code/config.json

scp ./config_pic.json $USERNAME@${IP_START}.6:~/PFG/Code/config.json
scp ./config_pic.json $USERNAME@${IP_START}.10:~/PFG/Code/config.json

scp ./config_mb.json $USERNAME@${IP_START}.11:~/PFG/Code/config.json
scp ./config_mb.json $USERNAME@${IP_START}.15:~/PFG/Code/config.json

scp ./config_mi.json $USERNAME@${IP_START}.12:~/PFG/Code/config.json
scp ./config_mi.json $USERNAME@${IP_START}.16:~/PFG/Code/config.json

scp ./config_mc.json $USERNAME@${IP_START}.13:~/PFG/Code/config.json
scp ./config_mc.json $USERNAME@${IP_START}.17:~/PFG/Code/config.json

scp ./config_mic.json $USERNAME@${IP_START}.14:~/PFG/Code/config.json
scp ./config_mic.json $USERNAME@${IP_START}.18:~/PFG/Code/config.json