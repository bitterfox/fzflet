#!/bin/bash

basedir=`dirname "$0"`

. $basedir/maven_config.sh

fzf_maven_fzf() {
    fzf --bind 'ctrl-r:clear-query+toggle-search+toggle-reload' \
        --bind "alt-a:execute-and-exit-on-success(FZFLET_MAVEN_SEARCH_CONTEXT=GROUP FZFLET_MAVEN_SEARCH_GROUP={1} $0 {1} < /dev/tty)" \
        --bind "alt-b:execute-and-exit-on-success(FZFLET_MAVEN_SEARCH_CONTEXT=ARTIFACT FZFLET_MAVEN_SEARCH_GROUP={1} FZFLET_MAVEN_SEARCH_ARTIFACT={2} $0 {1} {2} < /dev/tty)" \
        --bind "alt-m:execute-silent($basedir/maven_format.sh maven {1} {2} {3} | xclip -sel clip)" \
        --bind "alt-g:execute-silent($basedir/maven_format.sh gradle {1} {2} {3} | xclip -sel clip)" \
        --bind "ctrl-o:execute-silent(xdg-open $FZFLET_MAVEN_OPEN_URL &)" \
        --header "toggle-reload: C-r, Search this group: A-a, Search this artifact: A-b, Copy maven: A-m, Copy gradle: A-g, Open: C-o" \
        --header-lines=1 \
        --delimiter=: \
        --preview="$basedir/$FZFLET_MAVEN_PREVIEW {1} {2} {3}" \
        "$@"
    # --bind "enter:execute-and-exit-on-success($basedir/maven_format.sh all {1} {2} {3})" \
}

fzf_maven() {
    result=`fzf_maven_fzf "$@"`

    exitCode=$?

    if [ $exitCode -eq 0 ]; then
        echo $result
    fi
    exit $exitCode
}

# if [ -n "$1" ]; then
    # FZF_DEFAULT_COMMAND="$basedir/$FZFLET_MAVEN_SEARCH '$1'" \
        # fzf_maven
if [ "$FZFLET_MAVEN_SEARCH_CONTEXT" == "GROUP" ]; then
    FZF_DEFAULT_COMMAND="$basedir/$FZFLET_MAVEN_SEARCH" \
                       fzf_maven
elif [ "$FZFLET_MAVEN_SEARCH_CONTEXT" == "ARTIFACT" ]; then
    FZF_DEFAULT_COMMAND="$basedir/$FZFLET_MAVEN_SEARCH" \
                       fzf_maven
elif [ -n "$1" ]; then
    FZF_DEFAULT_COMMAND="$basedir/$FZFLET_MAVEN_SEARCH $1" \
                       fzf_maven
else
    FZF_DEFAULT_COMMAND="echo 'Type to search maven repository $FZFLET_MAVEN_NAME'" \
                       fzf_maven --disabled --bind "change:reload($basedir/$FZFLET_MAVEN_SEARCH {q})"
fi

