#!/bin/bash
# /usr/bin/cpulimit_daemon.sh
# ==============================================================
# CPU limit daemon - set PID's max. percentage CPU consumptions
# ==============================================================

# Variables
CPU_LIMIT=50            # Maximum percentage CPU consumption by each PID
DAEMON_INTERVAL=3       # Daemon check interval in seconds
BLACK_PROCESSES_LIST=   # 仅仅限制此黑名单中的进程 Limit only processes defined in this variable. If variable is empty (default) all violating processes are limited.
WHITE_PROCESSES_LIST=   # 白名单的进程除外。 Limit all processes except processes defined in this variable. If variable is empty (default) all violating processes are limited.

# Check if one of the variables BLACK_PROCESSES_LIST or WHITE_PROCESSES_LIST is defined.
if [[ -n "$BLACK_PROCESSES_LIST" &&  -n "$WHITE_PROCESSES_LIST" ]] ; then    # -n: "STRING" 的长度为非零 non-zero则为真。 If both variables are defined then error is produced.
   echo "At least one or both of the variables BLACK_PROCESSES_LIST or WHITE_PROCESSES_LIST must be empty."
   exit 1
elif [[ -n "$BLACK_PROCESSES_LIST" ]] ; then                                 # If this variable is non-empty then set NEW_PIDS_COMMAND variable to bellow command
  # top -b: batch model, 将输出发送给其他程序或者文件
  #     -n: number of iterations: 迭代的次数
  #     -c: 加上启动程序的命令行详细信息
  NEW_PIDS_COMMAND="top -b -n1 -c | grep -E '$BLACK_PROCESSES_LIST' | gawk '\$9>CPU_LIMIT {print \$1}' CPU_LIMIT=$CPU_LIMIT" # grep -E 扩展(Extended)的正则表达式
elif [[ -n "$WHITE_PROCESSES_LIST" ]] ; then                                 # If this variable is non-empty then set NEW_PIDS_COMMAND variable to bellow command
   NEW_PIDS_COMMAND="top -b -n1 -c | gawk 'NR>6' | grep -E -v '$WHITE_PROCESSES_LIST' | gawk '\$9>CPU_LIMIT {print \$1}' CPU_LIMIT=$CPU_LIMIT"  # -v: invert-match
else
   # awk '{if($2!="d") print $0}'
   NEW_PIDS_COMMAND="top -b -n1 -c | gawk 'NR>6 && \$9>CPU_LIMIT {print \$1}' CPU_LIMIT=$CPU_LIMIT"
fi

# Search and limit violating PIDs
while sleep $DAEMON_INTERVAL
do
   NEW_PIDS=$(eval "$NEW_PIDS_COMMAND")                                                                    # Violating PIDs
   LIMITED_PIDS=$(ps -eo args | gawk '$1=="cpulimit" {print $3}')                                          # Already limited PIDs
   QUEUE_PIDS=$(comm -23 <(echo "$NEW_PIDS" | sort -u) <(echo "$LIMITED_PIDS" | sort -u) | grep -v '^$')   # PIDs in queue comm - 23只显示在第一个文件中出现而未在第二个文件中出现的行；

   for i in $QUEUE_PIDS
   do
       #cpulimit -p $i -l $CPU_LIMIT -z &   # Limit new violating processes
       echo "jjj" | sudo -S cpulimit -p $i -l $CPU_LIMIT -z &   # 普通用户可以执行这个脚本
   done
done
