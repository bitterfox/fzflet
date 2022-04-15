#!/bin/bash

basedir=`dirname $0`
. $basedir/gh_config.sh

repository=$1
pull_number=`echo $2 | sed -r "s/#([0-9]+)/\1/"`

response=`gh api --hostname $FZFLET_GITHUB_HOSTNAME repos/$repository/pulls/$pull_number`

#echo gh api --hostname $FZFLET_GITHUB_HOSTNAME repos/$repository/pulls/$pull_number

base=`echo "$response" | jq -r ".base.label"`
head=`echo "$response" | jq -r ".head.label"`
user=`echo "$response" | jq -r ".user.login"`
assignees=`echo "$response" | jq -r ".assignees[].login"`
title=`echo "$response" | jq -r ".title"`
title_length=${#title}
#printf "%${FZF_PREVIEW_COLUMNS}s\n" "$base..$head"
echo $base..$head
printf "%s%$((FZF_PREVIEW_COLUMNS - title_length))s" "$title" "by $user"
echo ---
echo "$response" | jq -r ".body"
echo "$response" | jq -r ".requested_reviewers[].login"
echo "$response" | jq -r ".requested_teams[].name"

gh api -H "Accept: application/vnd.github.v3.diff" --hostname $FZFLET_GITHUB_HOSTNAME repos/$repository/pulls/$pull_number | batcat --color=always

gh api --hostname $FZFLET_GITHUB_HOSTNAME repos/$repository/pulls/$pull_number/comments | jq -r '.[].diff_hunk' | batcat --color=always --language=diff
gh api --hostname $FZFLET_GITHUB_HOSTNAME repos/$repository/pulls/$pull_number/comments | jq -r '.[].body'

gh api --hostname $FZFLET_GITHUB_HOSTNAME repos/$repository/issues/$pull_number/comments | jq -r '.[].body'
