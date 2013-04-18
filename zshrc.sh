# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

######################### vcs prompt info ############################
autoload -Uz promptinit
promptinit
prompt adam1

ENABLE_VCS_INFO="true"
VCS_INFO_SHOW_TRACKING_BRANCH="true"
#PS1='%{[%B%}%* %n@%2m %~%{%b%}]%{%F{yellow}%}%1v%{%f%} %{%F{red}%}%(?..(%?%))%{%f%}$'
#RPROMPT=

source .files/vcs_info.sh

######################### prompt options #############################
#export RPROMPT="%{${fg[yellow]}%}%B%1v%b"
export RPROMPT='%{%F{yellow}%}%1v%{%f%} %{%F{red}%}%(?..(%?%))%{%f%}'

#setopt prompt_subst
#autoload -Uz vcs_info

#zstyle ':vcs_info:*' enable git
#zstyle ':vcs_info:git*:*' get-revision true
#zstyle ':vcs_info:git*:*' check-for-changes true
#zstyle ':vcs_info:git*' formats '%b'
#zstyle ':vcs_info:git*' formats "%{$fg[grey]%}%s %{$reset_color%}%r/%S%{$fg[grey]%} %{$fg[blue]%}%b%{$reset_color%}%m%u%c%{$reset_color%}"

#precmd () { vcs_info }

#export RPROMPT="${vcs_info_msg_0_}"

######################### history options ############################
setopt EXTENDED_HISTORY        # store time in history
setopt HIST_IGNORE_ALL_DUPS    # ignore duplicate history items
setopt SHARE_HISTORY           # share history between prompts
setopt HIST_VERIFY	       # perform history substitution and reload
HISTSIZE=1000                  # spots for duplicates/uniques
SAVEHIST=1000                  # unique events guaranteed
HISTFILE=~/.zsh_history

######################### zsh options ################################
setopt AUTO_PUSHD              # push directories on every cd
setopt AUTO_NAME_DIRS          # change directories to variable names

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2

if [[ -x "`whence -p dircolors`" ]]; then
   eval "$(dircolors -b)"  # Mac doesn't like this line
fi

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Setup default aliases
alias ll="ls -l"
alias la="ls -a"
alias lal="ls -al"
alias lltr="ls -ltr"
alias e="emacs -nw"
alias E="emacs"
alias mkdir="mkdir -p"

# Setup .. behavior
function convertMultiDot() {
    if [[ ${LBUFFER} == *.. ]]
    then
        LBUFFER+=/..
    else
        LBUFFER+=.
    fi
}

zle -N convertMultiDot
bindkey . convertMultiDot

# Setup default options
setopt DVORAK

bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

export EDITOR=emacs