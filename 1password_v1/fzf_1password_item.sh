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
fields=`jq '.details.fields' <<< $item`

if [ $? -ne 0 ]; then
item=`$basedir/1password_get_item.sh --evict-cache $item_uuid`
#fields=`jq '.details.fields + [.details.sections[].fields[]]' <<< $item`
fields=`jq '.details.fields' <<< $item`
fi

username=`jq -r '.[] | select(.designation == "username") | .value' <<< $fields`
password=`jq -r '.[] | select(.designation == "password") | .value' <<< $fields`

title=`jq -r '.overview.title' <<< $item`
url=`jq -r '.overview.url' <<< $item`
tags=`jq -r '.overview.tags | join(",")' <<< $item`

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
    jq -c '.details.sections[].fields[]' <<< $item | while read field; do
        n=`jq -r '.n' <<< $field`
        k=`jq -r '.k' <<< $field`
        label=`jq -r '.t' <<< $field`
        value=`jq -r '.v' <<< $field`
        if [ "$k" == "concealed" ]; then
            concealed_value=`jq -r '(.v | length)*"*"' <<< $field`
            echo "Fill $label($n): $concealed_value"
        else
            echo "Fill $label($n): $value"
        fi
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
