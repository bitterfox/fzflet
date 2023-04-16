#!/bin/bash

path=`echo "$1" | cut -c 4-`

echo $path
echo "+ Staged changes"
git diff --color=always --staged $path
echo
echo "- Unstaged changes"
git diff --color=always $path
