# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
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
if [ -x /usr/bin/dircolors ]; then
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

export PATH=$PATH:/home/d/workspace/AI/tools/shell

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
source /opt/ros/melodic/setup.bash

export GUROBI_HOME=/home/d/software/gurobi811/linux64
export PATH=${PATH}:${GUROBI_HOME}/bin
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${GUROBI_HOME}/lib

unset http_proxy
unset https_proxy


cd_ll()
{
  # 使用‘\’可以调用原始命令
  \cd $1
  ll
}
alias cd='cd_ll'

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
alias pwd="pwd | cb"

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
# alias t='top -c -u d -d 1'
alias mat='matlab'
alias kl='kill -s 9'
alias dk='docker'
alias dki='docker images'
alias dkp='docker ps -a'
alias ref='source ~/.bashrc'
#alias kpy='ps aux | grep pycharm | awk '{print $2}' | xargs kill -s 9'

#alias klmat="ps aux | grep MATLAB | grep d | grep -v color | awk '{print $2}' | xargs kill -s 9"
# ps aux | grep screen | awk '{print $2}' | xargs kill -s 9
alias iftop='sudo iftop -i enp0s31f6 -B -N'
# login service 2 
alias sw='sshpass -p "123" ssh whd@115.157.195.198' # sudo apt install sshpass
alias sd='sshpass -p "kkk" ssh d@115.157.195.198'
alias vb='vi ~/.bashrc'

# git 
alias gts='git status'

# kill limitcpu
# ps aux | grep cputool | awk '{print $2}' | xargs kill -s 9

cd /data2/whd/workspace
. /home/d/anaconda3/etc/profile.d/conda.sh
