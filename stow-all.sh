#!/bin/bash
set -euo pipefail

# NOTE: Requires GNU Stow >= 2.4
# Earlier versions (2.3) have a bug with --dotfiles that causes:
# "stow_contents() called with non-directory path"
# See: https://github.com/aspiers/stow/issues/33
for dir in *; do
  if [[ ! -d "$dir" ]] || [[ "$dir" == "disabled" ]] || [[ "$dir" == "assets" ]]; then
    # Skip if not a directory or if it's named "disabled"
    continue
  fi
  echo "Stowing dotfiles from: $dir"
  stow --dotfiles "$dir"
done
