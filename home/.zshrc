#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Customize to your needs...

## antigen
source /usr/local/share/antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle heroku
antigen bundle pip
antigen bundle lein
antigen bundle command-not-found
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle mafredri/zsh-async
antigen bundle sindresorhus/pure

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# Activate zsh-completions
if [ -e $HOME/.zsh/completion ]; then
  fpath=($HOME/.zsh/completion $fpath)
fi

# Tell Antigen that you're done.
antigen apply

## utility
alias ll="ls -laG"

## git
alias gbr="git branch"
alias gch="git checkout"
alias gpl="git pull"
alias gst="git status"
alias gdi="git diff"
alias gad="git add"
alias gco="git commit"
alias grs="git reset"
alias gps="git push origin"
alias gdl="git branch -D"
alias gpk="git cherry-pick"

## docker
alias dce="docker compose exec"
alias dcu="docker compose up"
alias dcr="docker compose run"


## golang
export GOPATH="$HOME/go"
export PATH="$HOME/go/bin:$PATH"

## peco
### git
function peco-src () {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-src
alias gcd="peco-src"
bindkey '^]' peco-src

### incremental-search
function peco-select-history() {
  BUFFER=$(\history -n -r 1 | peco --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

## direnv
eval "$(direnv hook zsh)"

## tmux
alias ta="tmux attach -t"
alias tl="tmux ls"
alias tn="tmux new -s"

[ -f ~/.zshrc.local ] && source ~/.zshrc.local
