#!/bin/zsh

fzflet_google_chrome_actions_path="$0"
fzflet_google_chrome_basedir() {
    dirname $fzflet_google_chrome_actions_path
}

GOOGLE_CHROME_CATEGORY=300

fzf_google-chrome_category_name() {
    echo "Chrome"
}

fzf_google-chrome_open_history_action() {
    priority=$1
    description=$2

    matches=`$(fzflet_google_chrome_basedir)/fzf_google-chrome_history.sh`
    ret=$?

    if [ $ret -eq 0 ] && [ -n "$matches" ]; then
        echo "$matches" | awk '{print $3}' | while read line; do
            xdg-open "$line" >/dev/null 2>&1
        done
    fi

    return $ret
}

fzf_google-chrome_open_history_action_category_name() {
    fzf_google-chrome_category_name
}

fzf_google-chrome_open_history_action_priorities() {
    echo $GOOGLE_CHROME_CATEGORY
}

fzf_google-chrome_open_history_action_descriptions() {
    echo "Open from history"
}
