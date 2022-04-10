#!/bin/bash

commit=`echo "$1" | sed -r 's/[^a-z0-9]*([a-z0-9]+)[^a-z0-9].*/\1/'`
$2 $commit
