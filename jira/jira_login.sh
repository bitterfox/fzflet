#!/bin/bash

if [ -f "$FZFLET_JIRA_GO_JIRA_PATH" ]; then
    # Login
    $FZFLET_JIRA_GO_JIRA_PATH -e $FZFLET_JIRA_URL -u $FZFLET_JIRA_USER session
    if [ $? -ne 0 ]; then
        if [ -f $HOME/.jira.d/config.yml ]; then
            mv $HOME/.jira.d/config.yml $HOME/.jira.d/config.yml.bak
        fi
        echo "password-source: stdin" > $HOME/.jira.d/config.yml
        echo -n "$FZFLET_JIRA_PASSWORD" | $FZFLET_JIRA_GO_JIRA_PATH -e $FZFLET_JIRA_URL -u $FZFLET_JIRA_USER login
        if [ -f $HOME/.jira.d/config.yml.bak ]; then
            mv $HOME/.jira.d/config.yml.bak $HOME/.jira.d/config.yml
        else
            rm $HOME/.jira.d/config.yml
        fi
    fi
fi
