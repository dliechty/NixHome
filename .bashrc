# base-files version 3.9-3

# if .bash_local exist, source it.
# .bash_local can be used to set machine-specific settings
# that isn't synced to Git
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bash_local" ]; then
    . "$HOME/.bash_local"
    fi
fi

PATH="$HOME/.local/bin:$PATH"

if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi


# Aliases
# #######

# Interactive operation...
alias rm='rm -i'
#alias cp='cp -i'
#alias mv='mv -i'

# Default to human readable figures
alias df='df -h'
alias du='du -h'

# Misc :)
alias less='less -r'                          # raw control characters
alias lessf='less -r --follow-name +F'        # follow by file name instead of file descriptor
alias whence='type -a'                        # where, of a sort

# Some shortcuts for different directory listings
alias ls='ls -hF --color=tty'                 # classify files in colour
alias dir='ls --color=auto --format=vertical'
alias vdir='ls --color=auto --format=long'
alias ll='ls -al'                              # long list
alias la='ls -A'                              # all but . and ..
alias l='ls -CF'                              #

export LESS="-R -Q"

# if .bash_local exist, source it.
# .bash_local can be used to set machine-specific settings
# that isn't synced to Git
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bash_local" ]; then
    . "$HOME/.bash_local"
    fi
fi

PATH="$HOME/.local/bin:$PATH"

# Configure nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# Don't run anything after this line in a non-interactive shell (like codex or claude code)
[[ $- != *i* ]] && return

# User defined aliases

alias sshs='ssh qwertyshoe.com'

# Delete all branches merged into the current branch except for main/master/dev
alias git-clean='git branch --merged | egrep -v "(^\*|master|main|dev)" | xargs git branch -d'

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

if command -v eza > /dev/null
then
    alias ls="eza --long --icons=always --no-filesize --no-time --no-user --no-permissions"
    alias ll="eza --all --long --header --icons=always"
    alias tree="eza --tree --level=3"
fi

if command -v bat > /dev/null
then
    alias cat="bat"
elif command -v batcat > /dev/null
then
    alias cat="batcat"
fi

alias stmux='start_tmux'


# Functions
# #########

# Powerline configuration
if [ -f /usr/share/powerline/bindings/bash/powerline.sh ]; then
    powerline-daemon -q
    POWERLINE_BASH_CONTINUATION=1
    POWERLINE_BASH_SELECT=1
    source /usr/share/powerline/bindings/bash/powerline.sh
fi

start_tmux() {
    if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
      tmux new-session -A -s main
    fi
}

# set up function dbash including tab completion to start a bash shell in a running docker image
if command -v docker > /dev/null 2>&1
then
    function dbash() { docker exec -it "$1" bash; }
    function dexec() { docker exec -it "$@"; }
    complete -F __docker_running_containers dbash
    complete -F __docker_running_containers dexec
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f ~/git/fzf-git.sh/fzf-git.sh ] && source ~/git/fzf-git.sh/fzf-git.sh

# set up better fzf previews.
show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else batcat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Enable zoxide if installed
if command -v zoxide > /dev/null 2>&1
then
    eval "$(zoxide init --cmd cd bash)"

    \builtin unalias cd &>/dev/null || \builtin true
    function cd() {
        __zoxide_z "$@" && ls -al
    }

    \builtin unalias cdi &>/dev/null || \builtin true
    function cdi() {
        __zoxide_zi "$@" && ls -al
    }
fi
