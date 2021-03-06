#!/bin/sh

cd $(dirname ${BASH_SOURCE[0]})

. ./runner.sh

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

    for i in $users; do
        userdel $i
    done
    groupdel $group

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
        cp -r ~/.ssh /home/$i/.ssh
        chown -R $i:$group /home/$i/
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
    pacman -S --noconfirm vim git zsh gcc make screen apache php php-apache
}

function setupUsers {
    for i in $users root; do
        su $i -c "cd ~/;
        if [ ! -e .oh-my-zsh ]; then
            git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh;
        fi;
        cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc;
        rm .bashrc .bash_history .bash_profile;
        git config --global user.email '$email';
        git config --global user.name '$name';
        git config --global core.editor vim;
        git config --global push.default matching;"
        chsh -s /bin/zsh $i
    done
}

function setupApache {
    groupdel http
    groupadd http
    su http -c 'mkdir ~/uploads/;'
    if [ "$(grep PHP /etc/httpd/conf/httpd.conf)" == "" ]; then
        cat << FILE >> /etc/httpd/conf/httpd.conf
# Use for PHP 5.x:
LoadModule php5_module modules/libphp5.so
AddHandler php5-script php
Include conf/extra/php5_module.conf
FILE
    fi
    systemctl enable httpd
    systemctl restart httpd
}

function resizeDisk {
    fdisk /dev/mmcblk0 << FILE
d
2
n
e
2


n
l


w
FILE
    echo 'Run this command after a reboot: "resize2fs /dev/mmcblk0p5"'
}

function optionalRestart {
    echo -n "Restart now? [Y/n]: "
    read answer
    if [ "$answer" == "n" ]; then
        return 0;
    fi
    systemctl reboot
}

runWithRetry rootPassword addUsers tweetIp setTimezone updateAll installAll setupUsers setupApache resizeDisk optionalRestart

