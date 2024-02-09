#!/bin/bash

DOTPATH=$(cd $(dirname $0); pwd)

# brew でインストールしたパッケージのバックアップ
brew bundle dump --file=${DOTPATH}/Brewfile

# home directory に配置している設定ファイルのバックアップ
cd ${DOTPATH}/home
for f in .??*
do
  cp "$HOME/$f" "$DOTPATH/home/$f"
done

# karabiner の設定ファイルのバックアップ
cp "${HOME}/.config/karabiner/karabiner.json" "${DOTPATH}/karabiner/karabiner.json"

# vscode の設定ファイルのバックアップ
cd ${DOTPATH}/vscode
for f in *.json
do
  cp "${VSCODE_PATH}/${f}" "${DOTPATH}/vscode/${f}"
done

cp "${HOME}/.vscodestyles.css" ${DOTPATH}/vscode/vscodestyles.css
