# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=1000
setopt autocd
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/Volumes/jasonmini-xt/jasonmini/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

alias ..="cd .."

alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~"
alias home="cd ~"
alias cdd="cd ~/Downloads"
alias cddoc="cd ~/Documents"
alias cddev="cd ~/sources" # adjust path to your dev folder if different

# Open current directory in Finder
alias o.="open ."

alias lsblk="diskutil list"

# Quick ls-based directory listings
alias l="ls -lh"
alias la="ls -lha"
alias ll="ls -lh"
alias lla="ls -lhA"
alias lt="ls -ltrh" # list by modification time, newest last

alias zshrc="vim ~/.zshrc"
alias srcrc="source ~/.zshrc"


setopt auto_menu
setopt correct



# zinit plugin manager
if [[ ! -f ${ZDOTDIR:-$HOME}/.zinit/bin/zinit.zsh ]]; then
  mkdir -p ~/.zinit && git clone https://github.com/zdharma-continuum/zinit ~/.zinit/bin
fi
source ~/.zinit/bin/zinit.zsh

# Plugins
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions

# brew install z
. /opt/homebrew/etc/profile.d/z.sh

# brew install fzf
# $(brew --prefix)/opt/fzf/install
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
