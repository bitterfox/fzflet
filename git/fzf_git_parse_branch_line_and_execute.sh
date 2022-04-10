#!/bin/bash

branch=`echo "$1" | awk '{print $1}'`
if [ "$branch" == '*' ]; then
    branch=`echo "$1" | awk '{print $2}'`
fi

$2 $branch
