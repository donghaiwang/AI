#! /bin/sh
# command content
echo 'jjj' | sudo -S /home/d/software/nginx-1.7.4/sbin/nginx
exit 0

# move to /etc/init.d/
# sudo update-rc.d launch_nginx.sh defaults 99
# sudo update-rc.d -f launch_nginx.sh remove
