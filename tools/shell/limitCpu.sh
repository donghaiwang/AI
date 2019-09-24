#!/bin/bash
# limit CPU usage when beyond limit  
# Run example on background:
# nohup ./limitCpu.sh &>/dev/nulr

ps aux | awk '{if($3>=200.0 && $1!="d") print $2}' | while read procid
do
    echo "jjj"|sudo -S cputool --cpu-limit=365 -p $procid
done



