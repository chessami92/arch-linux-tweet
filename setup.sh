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
    users="cnc http"
    group=cnc

    echo Setting up git for all users.
    echo -n "Enter your email address: "
    read email
    echo -n "Enter your first and last name: "
    read name

    if [ ! -e ~/.ssh/id_rsa ]; then
        ssh-keygen -t rsa -C $email <<< $'\n'
    fi

    groupadd $group
    for i in $users; do
        useradd -m -g $group $i
        echo -n "Enter password for the $i account: "
        read -s password
        echo
        passwd $i << FILE
$password
$password
FILE
        rm -r /home/$i/.ssh/
        cp -r ~/.ssh /home/$i/
        chown -R $i:$group /home/$i/.ssh/
    done
}

function tweetIp {
    echo -n "Enter twitter username: "
    read username
    echo -n "Enter twitter Password: "
    read -s password
    echo

    tweetUser=cnc
    tweetGroup=cnc

    su $tweetUser -c 'mkdir ~/tweet;'
    replaceUser="s/replaceusername/$username/"
    replacePassword="s/replacepassword/$password/"
    file=/home/$tweetUser/tweet/tweet.sh
    sed -e $replaceUser -e $replacePassword tweet.sh > $file
    chown $tweetUser:$tweetGroup $file
    chmod 744 $file
    file=/home/$tweetUser/tweet/tweet.service.tmp
    cp tweet.service $file
    chown $tweetUser:$tweetGroup $file

    su $tweetUser -c 'cd ~/tweet;
    replaceUser="s/replaceusername/$USER/";
    execPath="$(pwd)/$(dirname $0)/";
    execPath=${execPath/.\//};
    execPath="${execPath//\//\\/}tweet.sh";
    replaceExecPath="s/replaceexecpath/$execPath/";
    sed -e $replaceUser -e $replaceExecPath tweet.service.tmp > tweet.service;
    rm tweet.service.tmp
    '

    file=/home/$tweetUser/tweet/tweet.service
    chown root:root $file
    mv $file /usr/lib/systemd/system/tweet.service

    systemctl daemon-reload
    systemctl start tweet
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

