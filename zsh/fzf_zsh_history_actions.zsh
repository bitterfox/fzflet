#!/bin/zsh

fzflet_zsh_actions_path="$0"
fzflet_zsh_basedir() {
    dirname $fzflet_zsh_actions_path
}

ZSH_CATEGORY=0

fzf_zsh_category_name() {
    echo "zsh"
}

fzf_zsh_history_action() {
    priority=$1
    description=$2

    matches=`$(fzflet_zsh_basedir)/fzf_zsh_history.sh ${LBUFFER}`
    ret=$?

    if [ $ret -eq 0 ]; then
        if [[ "`echo "$matches" | wc | awk '{print $ 1}'`" == "1" ]]; then
            LBUFFER="$matches"
            zle fzf-redraw-prompt
            typeset -f zle-line-init >/dev/null && zle zle-line-init
        else
            n=`echo "$matches" | tail -n +2 | head -n 1 | awk '{print $1}'`
            # https://unix.stackexchange.com/questions/244521/how-can-i-replace-a-literal-n-with-a-newline-character-on-os-x
            echohist() { ! cat "$1" }
            m=`FCEDIT=echohist fc $n`
            LBUFFER="$m"
            zle fzf-redraw-prompt
            typeset -f zle-line-init >/dev/null && zle zle-line-init
        fi
    elif [ $ret -eq 1 ]; then
        LBUFFER="$matches"
        zle fzf-redraw-prompt
        typeset -f zle-line-init >/dev/null && zle zle-line-init
    fi

    return $ret
}
zle     -N   fzf_zsh_history_action

if [ -n "$FZFLET_ZSH_HISTORY_ACTION_KEY" ]; then
    bindkey "$FZFLET_ZSH_HISTORY_ACTION_KEY" fzf_zsh_history_action
fi

fzf_zsh_history_action_category_name() {
    fzf_zsh_category_name
}

fzf_zsh_history_action_priorities() {
    echo $ZSH_CATEGORY
}

fzf_zsh_history_action_descriptions() {
    echo "History"
}
