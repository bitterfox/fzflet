#!/bin/bash

query="`echo $@ | sed -r "s/^\s+//" | sed -r "s/\s+$//" | sed -r "s/\s+/ -q /g"`"

if [ -z "$query" ]; then
    ag --color .
fi

ag --color $query

if [ $? -ne 0 ]; then
    echo "$query Not found"
fi
