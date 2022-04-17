#!/bin/bash

basedir=`dirname $0`
. $basedir/../util/common.sh

. $basedir/default.rc
load_config

cache=`cache_dir google-chrome`

history_path="$FZFLET_GOOGLE_CHROME_CONFIG_PATH/Default/History"

cp $history_path $cache

url_where="$1"

#sqlite3 $cache/History '.separator "<>"' "select last_visit_time/1000000-11644473600,visit_count,typed_count,url,title from  urls order by last_visit_time desc" | awk -F'<>' '{print int(($2 + $3) / 10) " " $1 " " $4 "  :  " $5}'
sqlite3 $cache/History '.separator "<>"' "SELECT last_visit_time/1000000-11644473600,visit_count,typed_count,url,title FROM urls WHERE url LIKE '%$url_where%'" | awk -F'<>' '{print int(sqrt(($2 + $3))) " " $1 " " $4 "  :  " $5}'
#sqlite3 $cache/History '.separator "<>"' "select title from urls order by last_visit_time desc"

# match=` | mysort | fzf --nth=3.. --tiebreak=index --header $sortkey`

# if [[ $? -eq 0 ]]; then
    # echo $match | awk '{print $3}' > $out
# fi

#match=`cat ~/.zsh_history | fzf`

#zsh -c "$match"
