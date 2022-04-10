#!/bin/zsh

output="$1"

basedir=`dirname $0`
. $basedir/../util/common.sh

login() {
    OP_SESSION_my=""
    while [ -z "$OP_SESSION_my" ]; do
        eval $(op signin my)
    done
}

session_path="`cache_dir 1password`/last_op_session_${USER}"
chmod 700 `dirname $session_path`
if [ -f $session_path ]; then
    . $session_path
else
    touch $session_path
    chmod 600 $session_path
fi

SESSION_EXPIRE=${SESSION_EXPIRE:-0}

if [ $SESSION_EXPIRE -lt `date +%s` ]; then
    echo "session expired"
    login

    LAST_ITEM=""
fi

SESSION_EXPIRE=`date -d "60 minutes" +%s`

run() {
    items="`$basedir/1password_list_items.sh`"
    if [ $? -ne 0 ]; then
        login
        items=`$basedir/1password_list_items.sh`
    fi
    echo "$items" | fzf --preview 'op --cache get item {1} | jq' \
                        --bind "ctrl-r:reload($basedir/1password_list_items.sh --evict-cache)" \
                        --bind "enter:execute-and-exit-on-success($basedir/fzf_1password_item.sh {1} $output)" \
                        --with-nth=2..
}

if [ -n "$LAST_ITEM" ]; then
    i="`$basedir/fzf_1password_item.sh "$LAST_ITEM" "$output"`"
    if [ $? -ne 0 ]; then
        i="`run`"
    fi
else
    i="`run`"
fi
item_uuid=`echo "$i" | head -n 1`
echo $i | tail -n +2

cat > $session_path <<EOF
export SESSION_EXPIRE="$SESSION_EXPIRE"
export OP_SESSION_my="$OP_SESSION_my"
export LAST_ITEM="$item_uuid"
EOF
