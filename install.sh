#!/bin/sh

echo Enter twitter credentials.
echo -n "Username: "
read username
echo -n "Password: "
read -s password
echo
replaceUser="s/replaceusername/$username/"
replacePassword="s/replacepassword/$password/"
sed -e $replaceUser -e $replacePassword tweet.sh > temp
mv temp tweet.sh
chmod 700 tweet.sh

replaceUser="s/replaceusername/$USER/"
execPath="$(pwd)/$(dirname $0)/"
execPath=${execPath/.\//}
execPath="${execPath//\//\\/}tweet.sh"
replaceExecPath="s/replaceexecpath/$execPath/"

sed -e $replaceUser -e $replaceExecPath tweet.service > tweet.service.tmp
echo Attempting su as root.
su -c 'chgrp root tweet.service.tmp; chown root tweet.service.tmp; cp tweet.service.tmp /usr/lib/systemd/system/tweet.service; rm tweet.service.tmp; systemctl enable tweet; systemctl start tweet'
