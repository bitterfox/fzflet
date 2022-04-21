#!/bin/zsh

HISTFILE=~/.zsh_history
HISTSIZE=999999999
fc -R

fc -rl 1 | sort -r -k 2 | uniq -f 1 | sort -r -n -k 1 | cut -d' ' -f3-
