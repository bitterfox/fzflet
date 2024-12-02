#!/bin/bash

basedir=`dirname $0`

item_uuid=$1

if [ -n "$2" ]; then
    output="$2"
    touch $output
    chmod 600 $output
else
    output="/dev/stdout"
fi

#item=`op --cache get item $item_uuid`
item=`$basedir/1password_get_item.sh $item_uuid`

#fields=`jq '.details.fields + [.details.sections[].fields[]]' <<< $item`
fields=`jq '.fields' <<< $item`

if [ $? -ne 0 ]; then
item=`$basedir/1password_get_item.sh --evict-cache $item_uuid`
#fields=`jq '.details.fields + [.details.sections[].fields[]]' <<< $item`
fields=`jq '.fields' <<< $item`
fi

username=`jq -r '.[] | select(.id == "username") | .value' <<< $fields`
password=`jq -r '.[] | select(.id == "password") | .value' <<< $fields`

title=`jq -r '.title' <<< $item`
url=`jq -r '.urls | map(.href) | join(",")' <<< $item`
tags=`jq -r '.tags | join(",")' 2> /dev/null <<< $item`

if [ -n "$tags" ]; then
    tags="[$tags] "
fi

show_fields() {
    fill_username
    fill_password
    fill_section
    copy_username
    copy_password
#    copy_other
}

fill_username() {
    if [ -n "$username" ]; then
        echo "Fill username: $username"
    fi
}
fill_password() {
    if [ -n "$password" ]; then
        echo "Fill password: ***"
    fi
}

fill_section() {
    jq -c '.sections[]' 2> /dev/null <<< $item | while read section; do
        id=`jq -r '.id' <<< $section`
        sectionLabel=`jq -r '.label' <<< $section`
        jq -c ".[] | select(.section.id == \"$id\")" <<< $fields | while read field; do
            type=`jq -r '.type' <<< $field`
            label=`jq -r '.label' <<< $field`
            value=`jq -r '.value' <<< $field`
            if [ "$type" == "CONCEALED" ]; then
                concealed_value=`jq -r '(.value | length)*"*"' <<< $field`
                echo "Fill $label($sectionLabel): $concealed_value"
            else
                echo "Fill $label($sectionLabel): $value"
            fi
        done
    done
}

copy_username() {
    if [ -n "$username" ]; then
        echo "Copy username: $username"
    fi
}
copy_password() {
    if [ -n "$password" ]; then
        echo "Copy password"
    fi
}

header="$tags$title $url"
result=`show_fields | fzf --preview "echo '$password'" --bind 'alt-p:toggle-preview' --preview-window=down:hidden --header "$header" --bind "ctrl-r:reload($basedir/1password_get_item.sh --evict-cache $item_uuid)"`

if [ $? -ne 0 ]; then
    exit 1
fi

echo $item_uuid
case "$result" in
    "Fill username: $username" ) echo -n "$username" > $output ;;
    "Fill password: ***" ) echo -n "$password" > $output ;;
    "Copy username: $username" ) echo -n "$username" | xsel -b -i ;;
    "Copy password" ) echo -n "$password" | xsel -b -i ;;
esac
