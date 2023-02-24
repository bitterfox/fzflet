#!/bin/bash

path="$1"

if [ -n "`command -v tree`" ]; then
    tree "$path"
else
    find "$path"
fi
