#!/bin/sh

function runWithRetry {
    for i in $@; do
        for j in 1 2 3; do
            $i
            if [ $? -eq 0 ]; then
                break
            fi
        done
    done
}
    
