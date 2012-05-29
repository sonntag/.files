#Turn on VCS, leave off branch tracking
export ENABLE_VCS_INFO="yes"

source ~/bin/fun.sh/fun.sh

#Use default envImprovement zsh prompt, except stick git stuff on the left if it's available
export PS1="%{${fg[$PROMPT_COLOR]}%}%B%n@%m]%{${fg[yellow]}%}%1v%{${fg[$PROMPT_COLOR]}%}$%b "

#Remove the extra space before the branch info
zstyle ':vcs_info:*' formats '[%b%u%c]%m'

alias ll="ls -l"
alias la="ls -a"
alias lal="ls -al"
alias lltr="ls -ltr"
alias ..="cd .."
alias ...="cd ../.."
alias e="emacs -nw"
alias E="emacs"
alias mkdir="mkdir -p"

setopt hist_ignore_all_dups
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

export EDITOR=emacs

# for source highlighting in less
export LESSOPEN="| /home/sonntagj/bin/src-hilite-lesspipe.sh %s"
export LESS=' -R '
