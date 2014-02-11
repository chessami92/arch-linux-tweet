A simple way to get the raspberry pi set up to run the cnc after installing arch linux. 

Run the following commands and you're set.

pacman -Sy git

git clone http://github.com/deltarobot/cnc-pi-setup/

./cnc-pi-setup/setup.sh

This also sets up a service that tweets from the 'cnc' user on system startup.

Thanks to http://360percents.com/posts/command-line-twitter-status-update-for-linux-and-mac/ for the tweeting code.

