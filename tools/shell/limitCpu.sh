#!/bin/bash
# limit CPU usage when beyond limit  
# Run example on background:
# nohup ./limitCpu.sh &>/dev/null

while true; do
    ps aux | awk '{if($3>=210.0 && $1!="d") print $2}' | while read procid
    do
        echo "jjj"|sudo -S cputool --cpu-limit=200 -p $procid
    done
    sleep 5s
done

exit 0




