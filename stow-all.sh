#!/bin/bash
set -euo pipefail
for dir in *; do
  if [[ ! -d "$dir" ]] || [[ "$dir" == "disabled" ]] || [[ "$dir" == "assets" ]]; then
    # Skip if not a directory or if it's named "disabled"
    continue
  fi
  echo "Stowing dotfiles from: $dir"
  stow --dotfiles "$dir"
done
