#!/bin/bash

basedir=`dirname $0`
. $dirname/gh_config.sh

owner_repo=$1
number=$2

gh pr view "$number" -R $FZFLET_GITHUB_HOSTNAME/$owner_repo -w
