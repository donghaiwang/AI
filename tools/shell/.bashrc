# !/bin/sh
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
# $-记录着当前设置的baishell选项 i：interactive-comments，
# 包含这个选项说明当前的 shell 是一个交互式的 shell。
# 所谓的交互式shell，就是输入命令后，shell解释执行，然后返回一个结果。
# 在脚本中，i选项是关闭的。
# 交互式的shell在tty终端从用户的输入中读取命令。
# 另一方面，shell能在启动时读取启动文件，显示一个提示符并默认激活作业控制。
case $- in           # 显示shell使用的当前选项，与set命令功能相同
    *i*) ;;          # 如果是 交互式运行 继续执行后面的,直接跳到esac之后
      *) return;;    # 判断是否含有i，没有就返回
esac
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
# 同时忽略 连续重复的命令(ignoredups) 和 以空白字符开头的命令(ignorespace)
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
# shopt(shell option) 命令用于显示和设置shell中的行为选项，通过这些选项以增强shell易用性
# -s 开启某个选项(ref:https://blog.csdn.net/u010003835/article/details/80760946)
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
# 设置历史命令最大能存储的条数
HISTSIZE=1000
# 设置历史命令存储文件的最大尺寸
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
# -x: 如果 FILE 存在且是可执行的则为真
# Shell [a-z]: https://www.cnblogs.com/wzq-xf/p/12197151.html
# 修改less显示德文件内容
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
# -z: “STRING” 的长度为零则为真。 -r: 如果 FILE 存在且是可读的则为真
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then  # dircolors: color setup for ls
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
# 按照文件扩展名展示
alias lx='ls -lXB'
# 按照文件大小排序展示
alias lk='ls -lSr'
# 按照时间排序展示
alias lt='ls -ltr'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Add login information
# /etc/update-motd.d/00-header

export PATH=$PATH:/usr/local/cuda/bin
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
# added by Anaconda3 2018.12 installer
# >>> conda init >>>
# !! Contents within this block are managed by 'conda init' !!
#__conda_setup="$(CONDA_REPORT_ERRORS=false '/home/d/anaconda3/bin/conda' shell.bash hook 2> /dev/null)"
#if [ $? -eq 0 ]; then
#    \eval "$__conda_setup"
#else
#    if [ -f "/home/d/anaconda3/etc/profile.d/conda.sh" ]; then
#        . "/home/d/anaconda3/etc/profile.d/conda.sh"
#        CONDA_CHANGEPS1=false conda activate base
#    else
#        \export PATH="/home/d/anaconda3/bin:$PATH"
#    fi
#fi
#unset __conda_setup
# <<< conda init <<<

#export PATH=$PATH:/usr/local/cuda-9.0/bin
#export LD_LIBRARY_PATH=/usr/local/cuda-9.0/lib64:$LD_LIBRARY_PATH
#export LD_LIBRARY_PATH=/usr/local/cuda-9.0/lib64:$LD_LIBRARY_PATH

export JAVA_HOME=/home/d/software/jdk1.8.0_191
export JRE_HOME=${JAVA_HOME}/jre
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib:$CLASSPATH
export JAVA_PATH=${JAVA_HOME}/bin:${JRE_HOME}/bin
export PATH=${JAVA_PATH}:$PATH

export PATH=$PATH:/usr/local/MATLAB/R2018a/bin

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/mpc-1.1.0/lib:/usr/local/gmp-6.1.2/lib:/usr/local/mpfr-4.0.1/lib:/usr/local/isl-0.18/lib:/usr/local/lib:/usr/lib/x86_64-linux-gnu

export M2_HOME=/home/d/software/apache-maven-3.6.0
export M2=$M2_HOME/bin
export PATH=$M2:$PATH
export PATH=/home/d/software:$PATH

#export PATH=$PATH:/data2/whd/software/arm-linux-gcc_toolschain/4.5.1/bin

export PATH=$PATH:/data2/whd/workspace/AI/tools/shell

export PATH=$PATH:/home/d/anaconda3/bin
export PATH=$PATH:/home/d/anaconda2/bin

#export PATH=$PATH:/home/d/software/pycharm-community-2018.1.2/bin
#export PATH=$PATH:/data2/whd/software/pycharm-community-2019.3.1/bin
export PATH=$PATH:/data2/whd/software/pycharm-2019.3.3/bin
export PATH=$PATH:/data2/whd/shortcut

# speedtest-cli
# export PATH=$PATH:/data2/whd/software

# Matlab Production Server
export PATH=$PATH:/data2/whd/software/MATLAB_Production_Server/R2018a/script

export PATH=$PATH:/home/d/software/gambit/bin/

# JabRef
export PATH=$PATH:/data2/whd/software/JabRef/bin/

# neuro: Caret
export PATH=$PATH:/data2/whd/workspace/sot/hart/utils/caret/bin_linux64

# matlab -> polyspace
export PATH=$PATH:/data2/whd/software/matlab_2020b/polyspace/bin
export PATH=$PATH:/data2/whd/software/matlab_2020b/bin


# export PATH=/data2/whd/software/node-v12.19.0-linux-x64/bin:$PATH

# added by Anaconda2 2018.12 installer
# >>> conda init >>>
# !! Contents within this block are managed by 'conda init' !!
#__conda_setup="$(CONDA_REPORT_ERRORS=false '/home/d/anaconda2/bin/conda' shell.bash hook 2> /dev/null)"
#if [ $? -eq 0 ]; then
#    \eval "$__conda_setup"
#else
#    if [ -f "/home/d/anaconda2/etc/profile.d/conda.sh" ]; then
#        . "/home/d/anaconda2/etc/profile.d/conda.sh"
#        CONDA_CHANGEPS1=false conda activate base
#    else
#        \export PATH="/home/d/anaconda2/bin:$PATH"
#    fi
#fi
#unset __conda_setup
# <<< conda init <<<

alias python='/home/d/anaconda2/envs/deepmot/bin/python'
# source /opt/ros/melodic/setup.bash

export GUROBI_HOME=/home/d/software/gurobi811/linux64
export PATH=${PATH}:${GUROBI_HOME}/bin
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${GUROBI_HOME}/lib
export LD_LIBRARY_PATH=/data2/whd/software/Qt5.12.9/5.12.9/gcc_64/lib:${LD_LIBRARY_PATH}

unset http_proxy
unset https_proxy


cd_ll()
{
  # 使用‘\’可以调用原始命令
  \cd $1
  ll
}

# 过滤指定名字的程序，比如：ps aux | grep pycharm
p()
{
    ps aux | grep $1
}

# 杀死pycharm
kp()
{
    ps aux | grep pycharm | awk '{print $2}' | xargs kill -s 9
}

cb() {
    local _scs_col="\e[0;32m"; local _wrn_col='\e[1;31m'; local _trn_col='\e[0;33m'
    # Check that xclip is installed.
    if ! type xclip > /dev/null 2>&1; then
	echo -e "$_wrn_col""You must have the 'xclip' program installed.\e[0m"
	# Check user is not root (root doesn't have access to user xorg server)
    elif [[ "$USER" == "root" ]]; then
	echo -e "$_wrn_col""Must be regular user (not root) to copy a file to the clipboard.\e[0m"
    else
	# If no tty, data should be available on stdin
	if ! [[ "$( tty )" == /dev/* ]]; then
	    input="$(< /dev/stdin)"
	    # Else, fetch input from params
	else
	    input="$*"
	fi
	if [ -z "$input" ]; then  # If no input, print usage message.
	    echo "Copies a string to the clipboard."
	    echo "Usage: cb <string>"
	    echo "       echo <string> | cb"
	else
	    # Copy input to clipboard
	    echo -n "$input" | xclip -selection c
	    # Truncate text for status
	    if [ ${#input} -gt 80 ]; then input="$(echo $input | cut -c1-80)$_trn_col...\e[0m"; fi
	    # Print status.
	    echo -e "$_scs_col""Copied to clipboard:\e[0m $input"
	fi
    fi
    input=""
}

#------------------------------------------------------------------------------
# 设置别名，让命令执行更便捷
# 这一部分最好放在最后，主要是因为前面的脚本可能会用到下面的命令
alias cd='cd_ll'
alias pwd="pwd | cb"
alias cl='clear'

# readlink命令，用于读取一个文件的绝对路径，复制文件的时候经常用到
alias rl='readlink -f'

# command output -> system clipboard
alias x="xclip -selection c"

alias mrun='matlab -nodesktop -nosplash -r'
# Add an "mrun" alias for running matlab in the terminal.
#alias mrun="matlab -nodesktop -nosplash -logfile `date +%Y_%m_%d-%H_%M_%S`.log -r"
alias mnd='matlab -nodisplay'
alias g='watch -n 1 nvidia-smi'
# alias top='htop -u d -d 5'
# alias t='top'
alias io='iostat -x -k'
alias t='top -c -u d -d 1'
alias mat='matlab'
alias kl='kill -s 9'
alias dk='docker'
alias dki='docker images'
alias dkp='docker ps -a'
# reload environment variable change and return to previous directory
alias ref='source ~/.bashrc; cd -'
#alias kpy='ps aux | grep pycharm | awk '{print $2}' | xargs kill -s 9'

#alias klmat="ps aux | grep MATLAB | grep d | grep -v color | awk '{print $2}' | xargs kill -s 9"
# ps aux | grep screen | awk '{print $2}' | xargs kill -s 9
alias iftop='echo "jjj" | sudo -S iftop -i enp0s31f6 -B -N'
alias duh='echo "jjj" | sudo du -h --max-depth=1'

# login service 2
alias sw='sshpass -p "123" ssh whd@115.157.195.198' # sudo apt install sshpass
alias sd='sshpass -p "kkk" ssh d@115.157.195.198'
alias vb='vi ~/.bashrc'

# git
alias gt='git status'
alias gd='git diff'
alias pu="git add .; git commit -m 'auto commit'; git push" # 自动add, commit, push

# kill limitcpu
# ps aux | grep cputool | awk '{print $2}' | xargs kill -s 9

# clear all GPU memory
# sudo fuser -v /dev/nvidia* |awk '{for(i=1;i<=NF;i++)print "kill -9 " $i;}' | sudo sh

# 会在qt启动时，列出详细的错误提示
export QT_DEBUG_PLUGINS=1

#setenv FREESURFER_HOME /data2/whd/software/freesurfer/

cd /data2/whd/workspace
. /home/d/anaconda3/etc/profile.d/conda.sh