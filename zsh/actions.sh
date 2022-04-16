#!/bin/zsh

fzflet_zsh_basedir=`dirname $0`
. $fzflet_zsh_basedir/../util/common.sh
. $fzflet_zsh_basedir/default.zsh.rc
load_config zsh

while read line; do
    . $line
done < <(find $fzflet_zsh_basedir/.. | grep "fzf_.*_actions\.zsh")

for extra in $FZFLET_ZSH_ACTIONS_EXTRA_PATHS; do
    while read line; do
        . $line
    done < <(find $FZFLET_ZSH_ACTIONS_EXTRA_PATHS | grep "fzf_.*_actions\.zsh")
done

select_action() {
    max_category_name_len=0
    print -l ${(ok)functions[(I)fzf_*_action]} | while read line; do
        while read category_name; do
            if [ $max_category_name_len -lt ${#category_name} ]; then
                max_category_name_len=${#category_name}
            fi
        done < <(${line}_category_name)
    done

    print -l ${(ok)functions[(I)fzf_*_action]} | while read line; do
        while read priority && read description <&3 && read category <&4; do
            printf "%s %d %-$((max_category_name_len + 2))s %s\n" \
                   $line $priority "[$category]" $description
        done < <(${line}_priorities) 3< <(${line}_descriptions) 4< <(${line}_category_name)
    done | sort -k 2,2n | fzf --with-nth=3.. --tiebreak=index
}

do_action() {
    action=$1
    priority=$2
    description=$3
    $action $priority $description
}

_fzf_actions() {
    select=`select_action`
    if [ $? -eq 0 ]; then
        action=`awk '{print $1}' <<< $select`
        priority=`awk '{print $2}' <<< $select`
        description=`sed -r 's/^[^ ]+ [^ ]+ (.*)/\1/' <<< $select`
        do_action $action $priority $description
    fi
#    typeset -f zle-line-init >/dev/null && zle zle-line-init
}

config_actions() {
    zle -N fzf_action _fzf_actions
    if [ -n "$FZFLET_ZSH_ACTIONS_KEY" ]; then
        bindkey $FZFLET_ZSH_ACTIONS_KEY fzf_action
    fi
}

config_actions
