#!/bin/bash

jetbrains_conf_dir="$HOME/.config/JetBrains"

version=$1
if [ -n "$version" ]; then
    intellij_conf_dir="$jetbrains_conf_dir/IntelliJIdea$version"
else
    intellij_conf_dir="$jetbrains_conf_dir/`ls $jetbrains_conf_dir | tail -n 1`"
fi

project=""
project_open_timestamp=0
while read line; do
    if [[ "$line" == *"entry key="* ]]; then
        project=`echo "$line" | sed -r 's/.*entry key=\"([^\"]*)\".*/\1/'`
    elif [ -n "$project" ]; then
        if [[ "$line" == *'projectOpenTimestamp'* ]]; then
           project_open_timestamp=`echo $line | sed -r 's/.*value="([0-9]+)".*/\1/'`
        elif [[ "$line" ==  *"</entry>"* ]]; then
            echo $project_open_timestamp $project

            project="a"
            project_open_timestamp=0
        fi
    fi
done < <(cat "$intellij_conf_dir/options/recentProjects.xml") | sed -r 's#\$USER_HOME\$#'"$HOME"'#'
