alias ll="ls -l"
alias la="ls -a"
alias lal="ls -al"
alias lltr="ls -ltr"
alias ..="cd .."
alias ...="cd ../.."
alias e="emacs -nw"
alias E="emacs"
alias mkdir="mkdir -p"

setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY
setopt DVORAK

bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

export EDITOR=emacs
