#!/bin/bash
# Link the editable Cursor settings. Home Manager owns keybindings.json.
set -eu

repo=$(cd "$(dirname "$0")" && pwd -P)
source_file="$repo/cursor/settings.json"
target_dir="$HOME/Library/Application Support/Cursor/User"
target="$target_dir/settings.json"

[[ -f "$source_file" ]]
mkdir -p "$target_dir"
if [[ -L "$target" && "$(readlink "$target")" == "$source_file" ]]; then
  exit 0
fi

if [[ -e "$target" || -L "$target" ]]; then
  backup=$(mktemp -d "$target_dir/.dotfiles-backup.XXXXXX")
  mv "$target" "$backup/settings.json"
  echo "Saved existing Cursor settings to $backup/settings.json"
  if ! ln -s "$source_file" "$target"; then
    mv "$backup/settings.json" "$target"
    exit 1
  fi
else
  ln -s "$source_file" "$target"
fi
