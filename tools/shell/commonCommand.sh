# limit specified user memory
sudo vi /etc/security/limits.conf
# @whd hard rss 10000000


# list user name who login in this computer(-delimiter -fields)
who | cut -d ' ' -f1 | sort | uniq

# code lines
find . "(" -name "*.m" -or -name ".cu" ")" -print | xargs wc -l

