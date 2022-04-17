#!/bin/bash

basedir=`dirname $0`

sortkey=${1:-often}
mysort() {
    case $sortkey in
        "often" ) sort -k 1nr,1 -k 2nr,2 ;;
        "recent" ) sort -k 2nr,2 -k 1nr,1 ;;
    esac
}

options=""

url="${2:-}"
url_desc="$url"
if [ "$DOMAIN" == "true" ]; then
    domain=`echo $url | sed -r "s#(.*)://([^/]*)/?(.*)#\2#"`
    url_desc="$domain"
    url="://$domain/"
else
    if [ -n "`echo "$url" | sed -r "s#.*://[^/]+/?(.*)#\1#"`" ]; then
        url_prev="`echo "$url" | sed -r "s#(.*)/(.+)#\1#"`"
        options="$options"$'\t'"--bind"$'\t'"alt-u:execute-and-exit-on-success($basedir/fzf_google-chrome_history.sh $sortkey '$url_prev')"
    fi
fi

IFS=$'\t'
$basedir/google-chrome_history.sh "$url" | \
    mysort | \
    fzf --preview-window down:20%:wrap \
        --preview "echo {}" \
        --nth=3.. \
        --tiebreak=index \
        --header "$sortkey $url_desc" \
        --bind "alt-a:execute-and-exit-on-success($basedir/fzf_google-chrome_history.sh $sortkey {3})" \
        --bind "alt-d:execute-and-exit-on-success(DOMAIN=true $basedir/fzf_google-chrome_history.sh $sortkey {3})" \
        --bind "ctrl-g:execute-and-exit-on-success(exit 0)" \
        $options
