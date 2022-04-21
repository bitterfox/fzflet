#!/bin/bash

basedir=`dirname $0`
. $basedir/../util/common.sh

. $basedir/gh_config.sh

# gh repo view --json url | jq -r '.url'
url=`gh repo view --json url | jq -r '.url'`
hostname=`echo $url | sed -r "s#http(s*)://([^/]+)/([^/]+)/([^/]+)#\2#"`
owner=`echo $url | sed -r "s#http(s*)://([^/]+)/([^/]+)/([^/]+)#\3#"`
repo=`echo $url | sed -r "s#http(s*)://([^/]+)/([^/]+)/([^/]+)#\4#"`

state=${1:-open}

next_state=`case $state in
  "open" ) echo "closed" ;;
  "closed" ) echo "all" ;;
  "all" ) echo "open" ;;
esac`

export FZFLET_GITHUB_HOSTNAME=$hostname
export FZFLET_GITHUB_USER=dummy

FZF_DEFAULT_COMMAND="$basedir/gh_pr_list.sh $hostname $owner $repo $state" \
                   fzf --preview-window right:50%:wrap \
                   --header "$state" \
                   --preview "FZFLET_GITHUB_HOSTNAME=$hostname $basedir/gh_preview_pull.sh $owner/$repo {1}" \
                   --bind "ctrl-r:reload($basedir/gh_pr_list.sh $hostname $owner $repo)" \
                   --bind "$FZFLET_GITHUB_OPEN_PULL_KEY:execute-silent(gh pr view {1} -R $hostname/$owner/$repo -w)" \
                   --bind "alt-s:execute-and-exit-on-success($basedir/fzf_gh_pr_list.sh $next_state)" \
                   --bind "ctrl-g:execute-and-exit-on-success(exit 0)" \
                   --bind "alt-c:execute-silent()"
