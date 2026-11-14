#!/bin/bash
set -euo pipefail

# NOTE: Requires GNU Stow >= 2.4
# Earlier versions (2.3) have a bug with --dotfiles that causes:
# "stow_contents() called with non-directory path"
# See: https://github.com/aspiers/stow/issues/33

cd "$(dirname "$0")"

for dir in */; do
  dir="${dir%/}"
  case "$dir" in
  # not stow packages
  assets | macos) continue ;;
  # By default, stow "folds" directories: if a target directory such as
  # ~/.claude does not exist yet, it creates ~/.claude itself as one symlink
  # to agents/dot-claude/ instead of making a real directory. Every file the
  # agent writes there afterwards (sessions, caches, credentials) would then
  # land inside this repo.
  #
  # --no-folding makes stow create ~/.agents, ~/.claude and ~/.codex as real
  # directories and symlink only the individual files from this package into
  # them, so the agents' own files stay out of the repo.
  agents) flags=(--no-folding) ;;
  *) flags=() ;;
  esac
  echo "Stowing dotfiles from: $dir"
  stow --dotfiles --target="$HOME" "${flags[@]+"${flags[@]}"}" "$dir"
done
