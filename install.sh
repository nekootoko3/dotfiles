#!/bin/bash

# ref: https://qiita.com/b4b4r07/items/b70178e021bef12cd4a2
# ref: https://qiita.com/b4b4r07/items/24872cdcbec964ce2178
# ref: https://github.com/kdnk/dotfiles

set -eu

REPO="github.com/nekootoko3/dotfiles"
GITHUB_URL="https://${REPO}"

DOTPATH=$(cd $(dirname $0); pwd)
VSCODE_PATH=${HOME}/Library/Application\ Support/Code/User

is_exists() {
  which "$1" >/dev/null 2>&1
  return $?
}

has() {
    is_exists "$@"
}

cd "${DOTPATH}"
if [ $? -ne 0 ]; then
    exit 1
fi

brew_install() {
  cd ${DOTPATH}

  # install brew itself
  if has "brew"; then
    echo "$(tput setaf 2)Already installed Homebrew ✔︎$(tput sgr0)"
  else
    echo "Installing Homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  # install formulae
  if has "brew"; then
    echo "Updating Homebrew..."
    brew update && brew upgrade
    [[ $? ]] && echo "$(tput setaf 2)Update Homebrew complete. ✔︎$(tput sgr0)"

    brew bundle install --file ${DOTPATH}/Brewfile
    [[ $? ]] && echo "$(tput setaf 2)Install Homebrew formulae complete. ✔︎$(tput sgr0)"

    # mas
    local -a formulae=(
#      '961632517' # Be Focused Pro
#      '865500966' # Feedly
#      '539883307' # line
#      '568494494' # pocket
    )
    for index in ${!formulae[*]}
    do
      mas install ${formulae[$index]}
    done

    echo "Cleanup Homebrew..."
    brew cleanup
    echo "$(tput setaf 2)Cleanup Homebrew complete. ✔︎$(tput sgr0)"
  fi
}

copy_home_files() {
  cd ${DOTPATH}/home
  for f in .??*
  do
    cp "$f" "$HOME/$f"
  done
}

copy_karabiner() {
  mkdir -p ${HOME}/.config/karabiner
  cp "${DOTPATH}/karabiner/karabiner.json" "${HOME}/.config/karabiner/karabiner.json"
}

vscode_enabled() {
  cd ${DOTPATH}/vscode

  for f in *.json
  do
    cp "${DOTPATH}/vscode/${f}" "${VSCODE_PATH}/${f}"
  done

  cp "${DOTPATH}/vscode/vscodestyles.css" ${HOME}/.vscodestyles.css
}

brew_install
copy_home_files
copy_karabiner
vscode_enabled
