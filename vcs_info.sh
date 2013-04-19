autoload -Uz vcs_info

zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' formats ' [%b%u%c]%m'
zstyle ':vcs_info:*' actionformats ' [%a|%b%u%c]'
zstyle -e ':vcs_info:git:*' check-for-changes 'vcs_info-cfc && reply=( true ) || reply=( false )'

if [[ -n "$VCS_INFO_SHOW_TRACKING_BRANCH" ]]; then
    zstyle ':vcs_info:git*+set-message:*' hooks git-untracked git-st git-remotebranch
else
    zstyle ':vcs_info:git*+set-message:*' hooks git-untracked git-st
fi

# Override this method to selectively disable VCS_INFO to check for changes
# for large repositories. Use $PWD to get the repo dir
vcs_info-cfc() {
    return 0
}

+vi-git-untracked(){
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
        git status --porcelain | grep '??' &> /dev/null ; then
        # This will show the marker if there are any untracked files in repo.
        # If instead you want to show the marker only if there are untracked
        # files in $PWD, use:
        #[[ -n $(git ls-files --others --exclude-standard) ]] ; then
        hook_com[staged]+='?'
    fi
}

### Compare local changes to remote changes

### git: Show +N/-N when your local branch is ahead-of or behind remote HEAD.
# Make sure you have added misc to your 'formats':  %m
function +vi-git-st() {
    local ahead behind
    local -a gitstatus

    # for git prior to 1.7
    # ahead=$(git rev-list origin/${hook_com[branch]}..HEAD | wc -l)
    ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l | tr -d ' ')
    (( $ahead )) && gitstatus+=( "↑${ahead}" )

    # for git prior to 1.7
    # behind=$(git rev-list HEAD..origin/${hook_com[branch]} | wc -l)
    behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l | tr -d ' ')
    (( $behind )) && gitstatus+=( "↓${behind}" )

    if [[ -n "$gitstatus" ]]; then
        hook_com[misc]+=" [${(j:/:)gitstatus}]"
    fi
}

### git: Show remote branch name for remote-tracking branches
function +vi-git-remotebranch() {
    local remote

    # Are we on a remote-tracking branch?
    remote=${$(git rev-parse --verify ${hook_com[branch]}@{upstream} \
        --symbolic-full-name 2>/dev/null)/refs\/remotes\/}

    # The first test will show a tracking branch whenever there is one. The
    # second test, however, will only show the remote branch's name if it
    # differs from the local one.


    if [[ -n ${remote} ]] ; then
    #if [[ -n ${remote} && ${remote#*/} != ${hook_com[branch]} ]] ; then
        if [[ ${#remote} -gt 25 ]]; then
            hook_com[branch]="${hook_com[branch]} >> ..${remote[-25, ${#remote}]}"
        else
            hook_com[branch]="${hook_com[branch]} >> ${remote}"
        fi
    fi
}

precmd_vcs_info() {
  vcs_info
  psvar=()
  [[ -n $vcs_info_msg_0_ ]] && psvar[1]="$vcs_info_msg_0_"
}

precmd_functions+='precmd_vcs_info'
precmd_functions+='__git_maybe_fetch'
