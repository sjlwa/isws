autoload -Uz promptinit
promptinit

autoload -U colors && colors
autoload -U compinit

zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

HISTFILE=~/.histfile
HISTSIZE=5000
SAVEHIST=5000

setopt HIST_IGNORE_ALL_DUPS
setopt autocd
bindkey -e
stty stop undef

alias ls='ls --color=aut'
alias grep='grep --color=auto'

bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

###

function ee() {
    setsid emacs $@ &
}

export DOTNET_ROOT=$HOME/.dotnet
export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools
