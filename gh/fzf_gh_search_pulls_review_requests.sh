#!/bin/bash

basedir=`dirname $0`
. $basedir/gh_config.sh

$basedir/fzf_gh_search_pulls.sh "$FZFLET_GITHUB_SEARCH_PULLS_REVIEW_REQUESTED_QUERY"
