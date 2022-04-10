#!/bin/bash

set -o pipefail
set -e

basedir=`dirname $0`
. $basedir/../util/common.sh

option="--cache"
evict_cache=0
if [ "$1" == "--evict-cache" ]; then
    option=""
    shift
fi

uuid=$1

op get item $uuid $option
