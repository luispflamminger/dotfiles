#!/bin/bash

selected=$(find ~/dev -mindepth 1 -maxdepth 6 -type d 2>/dev/null | fzf)

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)

if ! tmux has-session -t=$selected_name 2> /dev/null; then
    tmux new-session -ds $selected_name -c $selected
fi

tmux switch-client -t $selected_name
