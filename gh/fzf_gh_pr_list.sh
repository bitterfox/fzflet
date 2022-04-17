#!/bin/bash

basedir=`dirname $0`

# gh repo view --json url | jq -r '.url'
url=`gh repo view --json url | jq -r '.url'`
hostname=`echo $url | sed -r "s#http(s*)://([^/]+)/([^/]+)/([^/]+)#\2#"`
owner=`echo $url | sed -r "s#http(s*)://([^/]+)/([^/]+)/([^/]+)#\3#"`
repo=`echo $url | sed -r "s#http(s*)://([^/]+)/([^/]+)/([^/]+)#\4#"`

export FZFLET_GITHUB_HOSTNAME=$hostname
export FZFLET_GITHUB_USER=dummy

FZF_DEFAULT_COMMAND="$basedir/gh_pr_list.sh $hostname $owner $repo" \
                   fzf --preview-window right:50%:wrap \
                   --preview "FZFLET_GITHUB_HOSTNAME=$hostname $basedir/gh_preview_pull.sh $owner/$repo {1}" \
                   --bind "ctrl-r:reload($basedir/gh_pr_list.sh $hostname $owner $repo)" \
                   --bind "ctrl-o:execute-silent(gh pr view {1} -R $hostname/$owner/$repo -w)" \
                   --bind "alt-c:execute-silent()"
