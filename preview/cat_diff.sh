#!/bin/bash

basedir=`dirname $0`

BATCAT_OPTS="--language=diff"

$basedir/cat.sh $@
