#!/bin/sh

function runWithRetry {
    for i in $@; do
        for j in 1 2 3; do
            $i
            if [ $? -eq 0 ]; then
                break
            else
                echo -n "Running $i failed. Try again? [Y/n]: "
                read answer
                if [ "$answer" == "n" ]; then
                    break;
                fi
            fi
        done
    done
}
    
