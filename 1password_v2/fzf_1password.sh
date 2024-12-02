#!/bin/zsh

output="$1"

basedir=`dirname $0`
. $basedir/../util/common.sh

login() {
    OP_SESSION_USER=""
    OP_SESSION_TOKEN=""
    while [ -z "$OP_SESSION_USER" ]; do
        eval $(op signin)
        OP_SESSION_VARIABLE=`env | grep "^OP_SESSION_"`
        if [ -n "$OP_SESSION_VARIABLE" ]; then
            export OP_SESSION_USER=`echo "$OP_SESSION_VARIABLE" | sed -r "s/OP_SESSION_([^=]+)=(.*)/\1/"`
            export OP_SESSION_TOKEN=`echo "$OP_SESSION_VARIABLE" | sed -r "s/OP_SESSION_([^=]+)=(.*)/\2/"`
        fi
    done
}

session_path="`cache_dir 1password`/last_op_session_${USER}"
chmod 700 `dirname $session_path`
if [ -f $session_path ]; then
    . $session_path
    eval "export OP_SESSION_$OP_SESSION_USER=$OP_SESSION_TOKEN"
else
    touch $session_path
    chmod 600 $session_path
fi

SESSION_EXPIRE=${SESSION_EXPIRE:-0}

if [ $SESSION_EXPIRE -lt `date +%s` ]; then
    echo "session expired"
    login

    LAST_ITEM=""
    SESSION_EXPIRE=`date -d "28 minutes" +%s`
fi

run() {
    items="`$basedir/1password_list_items.sh`"
    if [ $? -ne 0 ]; then
        login
        items=`$basedir/1password_list_items.sh`
    fi
    echo "$items" | fzf --preview 'op --cache item get {1} --format=json | jq' \
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
export OP_SESSION_USER="$OP_SESSION_USER"
export OP_SESSION_TOKEN="$OP_SESSION_TOKEN"
export LAST_ITEM="$item_uuid"
EOF
