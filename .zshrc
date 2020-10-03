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

## command line
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
alias mtr="git checkout master"

alias hubr="hub browse"

## ruby
eval "$(rbenv init -)"
alias be="bundle exec"

## rust
export PATH="$HOME/.cargo/bin:$PATH"

## postgres
export PATH=/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH

## nodenv
export PATH="$HOME/.nodenv/bin:$PATH"
eval "$(nodenv init -)"

## golang
export PATH="$HOME/go/bin:$PATH"
export GO111MODULE=on
export GOPATH="$HOME/go"

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

## python
#export PATH=$HOME/Library/Python/3.7/bin:$PATH

# added by travis gem
[ -f $HOME/.travis/travis.sh ] && source $HOME/.travis/travis.sh

## vs code
alias c="code"

## tmux
alias ta="tmux attach -t"
alias tl="tmux ls"
alias tn="tmux new -s"

[ -f ~/.zshrc.local ] && source ~/.zshrc.local
