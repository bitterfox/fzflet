#!/bin/bash

path=$1
line=$2

if [ -n "command -v batcat" ]; then
    options="-n"
    if [ -n "$line" ]; then
        options="$options -H $line"
    fi
    batcat --color=always $options $path
else
    options=""
    if [ -n "$line" ]; then
        options="-n"
    fi
    cat $options $path
fi
