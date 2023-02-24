#!/bin/bash

dir=$1

find_dir="`eval "command find -L "$dir" | head -n 1"`"
dirlen="${#find_dir}"

case "${FZFLET_FILES_FIND_TARGET:-file}" in
    "file") option="-type f -print -o -type l -print" ;;
    "dir") option="-type d -print" ;;
    "all") option="-type d -print -o -type f -print -o -type l -print" ;;
esac

if [[ "$FZFLET_FILES_FIND_HIDDEN" == "true" ]]; then
        cmd="${FZF_CTRL_T_COMMAND:-"command find -L "$dir" -mindepth 1 \\( -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
              -o $option 2> /dev/null | cut -b$((dirlen + 1))-"}"
else
        cmd="${FZF_CTRL_T_COMMAND:-"command find -L "$dir" -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
              -o $option 2> /dev/null | cut -b$((dirlen + 1))-"}"

        # if dir is hidden file, above command cannot find any
        # fallback to allow hidden file
        if [ -n "$dir" ] && [[ "`eval "$cmd" | head -n 2 | wc | awk '{print $1}'`" == "0" ]]; then
            cmd="${FZF_CTRL_T_COMMAND:-"command find -L "$dir" -mindepth 1 \\( -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
              -o $option 2> /dev/null | cut -b$((dirlen + 1))-"}"
        fi
fi

eval "$cmd"
