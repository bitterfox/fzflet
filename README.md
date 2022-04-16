# Fzflet

fzflet is a collection of small scripts for various integrations with fzf and external tools.

fzflet requires enhanced fzf features implemented in https://github.com/bitterfox/fzf/commits/develop

# Supported integrations
- Files
  - Find file (Similar to the original one)
  - Go to directory (Similar to the original one)
- git
  - branch
  - graph
  - blame
  - show
- Github (Requires Github CLI https://cli.github.com/)
  - notifications
  - List PRs for current repository
  - List PRs created by me
  - List PRs review requested to me
- ag (require enhanced ag https://github.com/bitterfox/the_silver_searcher/tree/develop)
- 1password CLI v1
- IntelliJ
  - Recent projects (Go to or Open)
- Jira
  - List tickets
  - Preview feature requires go-jira cli https://github.com/go-jira/jira

# Integration with zsh
fzflet is not only the collection of small fzf scripts, but also a extensible framework of fzf+zsh integration, called fzf action.
fzf actions are a zsh widget that can complete the buffer like https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh or run external command like run IntelliJ, open browser or copy to clipboard, easily triggered from zsh session and easily choose from the action list.
You can call each action by key bind or by selecting action in `_fzf_action` (the default key bind to call `_fzf_action` is `C-<SPC>`)

To enable fzf actions in zsh session, load `zsh/actions.sh`.
```
. fzflet/zsh/actions.sh
```

It loads `fzf_.*_actions.zsh` under fzflet dir to lookup available actions.
You can implement your custom actions by defining following functions for each actions in the file named `fzf_.*_actions.zsh`
```
fzf_<name>_action
fzf_<name>_action_category_name
fzf_<name>_action_priorities
fzf_<name>_action_descriptions
```

`fzf_<name>_action` takes `priority` and `descriptions` and run the action you want.
`fzf_<name>_action_category_name` returns category names that can be useful to the user can understand the grouping of actions
`fzf_<name>_action_priorities` returns numbers as the priority for `_fzf_action` to sort the actions (0<=1000 is used by fzflet preset actions, your custom actions should use 1000<=).
This number can be used for id of the action if you want to define multiple actions for the same action like you'd like to define the same action for different Github instance such as the Github and your GHE.
`fzf_<name>_action_descirptions` returns descirptions for the action.

Finally, you add the path for `_fzf_action` to lookup your custom action to `FZFLET_ZSH_ACTIONS_EXTRA_PATHS` in ~/.fzflet.zsh.rc
```
export FZFLET_ZSH_ACTIONS_EXTRA_PATHS=($HOME/my/custom/fzflet/actions)
```
