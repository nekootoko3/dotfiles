#!/bin/bash

# ref: https://qiita.com/b4b4r07/items/b70178e021bef12cd4a2
# ref: https://qiita.com/b4b4r07/items/24872cdcbec964ce2178
# ref: https://github.com/kdnk/dotfiles

set -eu

REPO="github.com/nekootoko3/dotfiles"
GITHUB_URL="https://${REPO}"

DOTPATH=$(cd $(dirname $0); pwd)

#is_exists() {
#  which "$1" >/dev/null 2>&1
#  return $?
#}
#
#has() {
#    is_exists "$@"
#}
#
#
#if has "git"; then
#    git clone --recursive "$GITHUB_URL" "$DOTPATH"
#else
#    exit 1
#fi

cd "${DOTPATH}"
if [ $? -ne 0 ]; then
    exit 1
fi

link_files() {
  cd ${DOTPATH}
  for f in .??*
  do
    [[ ${f} = ".git" ]] && continue
    [[ ${f} = ".gitignore" ]] && continue

    ln -snfv "$DOTPATH/$f" "$HOME/$f"
  done

  # karabiner
  mkdir -p ${HOME}/.config/karabiner
  ln -snfv "${DOTPATH}/karabiner/karabiner.json" "${HOME}/.config/karabiner/karabiner.json"
}

brew_install() {
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

    local list_formulae=()
    local -a missing_formulae=()
    local -a desired_formulae=(
      'readline'
      'go'
      'rbenv'
      'the_platinum_searcher'
      'tmux'
      'zsh'
      'peco'
      'nodenv'
      'direnv'
      'ghq'
      'antigen'
      'redis'
      'jq'
      'awscli'
      'hub'
      'antigen'
      'reattach-to-user-namespace'
      'autoconf'
      'wget'
      'yarn'
    )

    local installed=`brew list`

    # desired_formulaeで指定していて、インストールされていないものだけ入れる
    for index in ${!desired_formulae[*]}
    do
      brew install ${desired_formulae[$index]}
#      local formula=`echo ${desired_formulae[$index]} | cut -d' ' -f 1`
#      if [[ -z `echo "${installed}" | grep "^${formula}$"` ]]; then
#        missing_formulae=("${missing_formulae[@]}" "${desired_formulae[$index]}")
#      else
#        echo "Installed ${formula}"
#      fi
    done

#    if [[ "$missing_formulae" ]]; then
#      list_formulae=$( printf "%s " "${missing_formulae[@]}" )
#
#      echo "Installing missing Homebrew formulae..."
#      brew install $list_formulae
#
#      [[ $? ]] && echo "$(tput setaf 2)Installed missing formulae ✔︎$(tput sgr0)"
#    fi
#
    # cask
#    local -a missing_formulae=()
    local -a desired_formulae=(
      'alfred'
      'slack'
      'dash'
      'bettertouchtool'
      'google-chrome'
      'karabiner-elements'
      'visual-studio-code'
      'skitch'
      'kindle'
      'postgres'
      'dropbox'
      'macvim'
    )
    local installed=`brew cask list`
#
    for index in ${!desired_formulae[*]}
    do
      brew cask install ${desired_formulae[$index]}
#      local formula=`echo ${desired_formulae[$index]} | cut -d' ' -f 1`
#      if [[ -z `echo "${installed}" | grep "^${formula}$"` ]]; then
#        missing_formulae=("${missing_formulae[@]}" "${desired_formulae[$index]}")
#      else
#        echo "Installed ${formula}"
#      fi
    done
#
#    if [[ "$missing_formulae" ]]; then
#      list_formulae=$( printf "%s " "${missing_formulae[@]}" )
#
#      echo "Installing missing Homebrew formulae..."
#      brew cask install $list_formulae
#
#      [[ $? ]] && echo "$(tput setaf 2)Installed missing formulae ✔︎$(tput sgr0)"
#    fi

    echo "Cleanup Homebrew..."
    brew cleanup
    echo "$(tput setaf 2)Cleanup Homebrew complete. ✔︎$(tput sgr0)"
  fi
}

zsh_enabled() {
  [ ${SHELL} != "/bin/zsh"  ] && chsh -s /bin/zsh
  echo "$(tput setaf 2)Initialize complete!. ✔︎$(tput sgr0)"
}

vim_enabled() {
  curl -fLo ${HOME}/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  mkdir -p ${HOME}/.vim/tmp
}

vscode_enabled() {
  cd ${DOTPATH}/vscode
  cat ./extensions.txt | xargs -L 1 code --install-extension
  VSCODE_PATH=${HOME}/Library/Application\ Support/Code/User

  for f in *.json
  do
    ln -snfv "${DOTPATH}/vscode/${f}" "${VSCODE_PATH}/${f}"
  done

#  ln -snfv "${DOTPATH}/vscode/vscodestyles.css" ${HOME}/.vscodestyles.css
}

brew_install
link_files
zsh_enabled
vim_enabled
vscode_enabled
