#!/bin/bash

basedir=`dirname "$0"`

. $basedir/maven_config.sh

result=`$basedir/fzf_maven_search.sh $@`

if [ $? -eq 0 ]; then
    echo $result
    echo
    echo $result | xargs -d : $basedir/maven_format.sh all
fi
