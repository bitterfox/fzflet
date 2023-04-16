#!/bin/bash

path=`echo "$1" | cut -c 4-`

git add -i $path < /dev/tty > /dev/tty
