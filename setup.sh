#!/bin/sh

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo $dir
. $dir/runner.sh

function rootPassword {
    echo -n "Enter password for root account: "
    read -s password1
    echo
    echo -n "Confirm password for root account: "
    read -s password2
    echo
    passwd << FILE
$password1
$password2
FILE
}

function addUsers {
    groupadd cnc
    useradd -m -g cnc cnc
    echo -n "Enter password for the cnc account: "
    read -s password
    echo
    passwd cnc << FILE
$password
$password
FILE
}

function tweetIp {
    echo -n "Enter twitter username: "
    read username
    echo -n "Enter twitter Password: "
    read -s password
    echo
    replaceUser="s/replaceusername/$username/"
    replacePassword="s/replacepassword/$password/"
    sed -e $replaceUser -e $replacePassword tweet.sh > temp
    su cnc -c 'mkdir ~/tweet;
    cd ~/tweet;
    pwd;
    cp /root/temp tweet.sh;
    replaceUser="s/replaceusername/$USER/";
    execPath="$(pwd)/$(dirname $0)/";
    execPath=${execPath/.\//};
    execPath="${execPath//\//\\/}tweet.sh";
    replaceExecPath="s/replaceexecpath/$execPath/";
    sed -e $replaceUser -e $replaceExecPath /root/tweet.service > tweet.service.tmp;
    '
    rm temp
    file=/home/cnc/tweet/tweet.service.tmp
    chgrp root $file
    chown root $file
    mv /home/cnc/tweet/tweet.service.tmp /usr/lib/systemd/system/tweet.service
}

function setTimezone {
    timedatectl set-timezone America/Chicago
}

function updateAll {
    pacman -Syu --noconfirm
}

function installAll {
    pacman -S --noconfirm vim git zsh gcc make
}

runWithRetry rootPassword addUsers tweetIp setTimezone updateAll installAll

