#!/bin/bash
# limit CPU usage when beyond limit  
# Run example on background:
# nohup ./limitCpu.sh &>/dev/null

limited_id=()
while true; 
do
  #limited_id=`ps -ef | grep cpulimit | grep -v "grep" | awk '{print $10}' | tail -1`
  #illegal_id=`ps aux | awk '{ if ($3 > 50 ) print $2 }' | head -1`
  #if [ "${illegal_id}" != "" ] && [ "${illegal_id}" != "${limited_id}" ]; then
  #  echo "jjj" | sudo -S cpulimit -p ${illegal_id} -l 50 &
  #  echo ${illegal_id}
  #fi

  # $0: 显示所有的列
  # TODO: 再次扫描时，需要过滤掉已经限制的进程（号）limited_id
  limited_id=`ps aux | awk '{if($11=="cpulimit" && $13~/^[0-9]+$/) print $13}'`
  # 使用空格对进程号进行分割
  limited_arr=(${limited_id// / })
  #for var in ${limited_arr[@]}
  #do
  #  echo $var
  #done
  # awk '{print $13~/^[0-9]+$/}'
  ps aux | grep -v "cpulimit" | awk '{if($3>75.0 && $1!="whd" && $1!="root") print $2}' | while read procid
  do
	for pid in $procid; do
	    # echo $pid
      # 运行cpulimit作为后台进程，使用--background或-b开关，释放终端
      #[[ ${limited_id[@]/$pid/} != ${limited_id[@]} ]] && echo "Existed" ||  echo "jjj" | sudo -S cpulimit -l 50 --pid $pid --lazy &

      # 遍历以限制的数组，如果存在则不需要限制
      for lim_id in ${limited_arr[@]}
      do
        if [ $lim_id -eq $pid ]; then
          exist=true
        fi
      done

      echo $exist
      echo "jjj" | sudo -S cpulimit --pid $pid -l 50 --lazy &
      #echo "jjj" | sudo -S cpulimit --pid $pid -l 50 --lazy &
	    #echo "jjj" | sudo -S cputool --cpu-limit=50 -p $pid &
    done
  done
  echo '*****************'
  # 每次扫描间隔的时间
  sleep 120s
#sleep 3
done

exit 0




