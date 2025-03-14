# base-files version 3.9-3

# To pick up the latest recommended .bashrc content,
# look in /etc/defaults/etc/skel/.bashrc

# Modifying /etc/skel/.bashrc directly will prevent
# setup from updating it.

# The copy in your home directory (~/.bashrc) is yours, please
# feel free to customise it to create a shell
# environment to your liking.  If you feel a change
# would be benificial to all, please feel free to send
# a patch to the cygwin mailing list.

# User dependent .bashrc file

# Environment Variables
# #####################

# TMP and TEMP are defined in the Windows environment.  Leaving
# them set to the default Windows temporary directory can have
# unexpected consequences.
unset TMP
unset TEMP

# Alternatively, set them to the Cygwin temporary directory
# or to any other tmp directory of your choice
# export TMP=/tmp
# export TEMP=/tmp

# Or use TMPDIR instead
# export TMPDIR=/tmp

# Shell Options
# #############

# See man bash for more options...

# Don't wait for job termination notification
# set -o notify

# Don't use ^D to exit
# set -o ignoreeof

# Use case-insensitive filename globbing
# shopt -s nocaseglob

# Make bash append rather than overwrite the history on disk
# shopt -s histappend

# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
# shopt -s cdspell

# Check window buffer size when resizing window
shopt -s checkwinsize

# Completion options
# ##################

# These completion tuning parameters change the default behavior of bash_completion:

# Define to access remotely checked-out files over passwordless ssh for CVS
# COMP_CVS_REMOTE=1

# Define to avoid stripping description in --option=description of './configure --help'
# COMP_CONFIGURE_HINTS=1

# Define to avoid flattening internal contents of tar files
# COMP_TAR_INTERNAL_PATHS=1

# If this shell is interactive, turn on programmable completion enhancements.
# Any completions you add in ~/.bash_completion are sourced last.
# case $- in
#   *i*) [[ -f /etc/bash_completion ]] && . /etc/bash_completion ;;
# esac


# History Options
# ###############

# Don't put duplicate lines in the history.
# export HISTCONTROL="ignoredups"

# Ignore some controlling instructions
# HISTIGNORE is a colon-delimited list of patterns which should be excluded.
# The '&' is a special pattern which suppresses duplicate entries.
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit'
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls' # Ignore the ls command as well

# Whenever displaying the prompt, write the previous line to disk
# export PROMPT_COMMAND="history -a"

# Aliases
# #######

# Some example alias instructions
# If these are enabled they will be used instead of any instructions
# they may mask.  For example, alias rm='rm -i' will mask the rm
# application.  To override the alias instruction use a \ before, ie
# \rm will call the real rm not the alias.

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

# User defined aliases

alias sshs='ssh qwertyshoe.com'

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

# Some example functions
# function settitle() { echo -ne "\e]2;$@\a\e]1;$@\a"; }

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

mvn_changed_modules() {
    [ -z "$1" ] && echo "Expected command : mvn_changed_modules (install/build/clean or any maven command)" && exit 0

    modules=$(git status | grep -E "modified:|deleted:|added:" | awk '{print $2}' | cut -f1 -d "/" | sort | uniq | paste -sd ",")

    if [ -z "$modules" ];
    then
        echo "No changes (modified / deleted / added)  found"
    else
        echo -e "Changed modules are : `echo $modules`\n\n"
        /mnt/c/Windows/system32/cmd.exe /c mvn.cmd $1 -amd -pl $modules
    fi
}

git() {
  if [[ $(pwd -P) = /mnt/c/* ]]; 
  then
    "/mnt/c/Program Files/Git/cmd/git.exe" "$@"
  else
    command git "$@"
  fi
}

gh() {
  if [[ $(pwd -P) = /mnt/c/* ]]; 
  then
    "/mnt/c/Program Files/GitHub CLI/gh.exe" "$@"
  else
    command gh "$@"
  fi
}

# Bash tab completion function that lists all running containers
__docker_running_containers() {
    local cur prev containers
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    containers=$(docker ps --format "{{.Names}}")

    COMPREPLY=($(compgen -W "$containers" -- "$cur"))
}

# Bash tab completion function that lists all images
__docker_images() {
    local cur prev containers
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    images=$(docker images --format "{{.Repository}}:{{.Tag}}")

    COMPREPLY=($(compgen -W "$images" -- "$cur"))
}


# set up function dbash including tab completion to start a bash shell in a running docker image
if command -v docker > /dev/null 2>&1
then
    function dbash() { docker exec -it "$1" bash; }
    function dexec() { docker exec -it "$@"; }
    complete -F __docker_running_containers dbash
    complete -F __docker_running_containers dexec
fi

# Set up tab completion for docker install script
if command -v ~/nextgate/docker/install.sh > /dev/null 2>&1
then
    complete -F __docker_images install.sh
fi

# Add bash settings specific to WSL (and not cygwin or some other bash environment)
if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null ; then

    # alias mvn to the windows executable to use windows env variables and really slow
    # disk IO
    alias mvn='/mnt/c/Windows/system32/cmd.exe /c mvn.cmd'

    export TERM=xterm-256color
    alias tmux="tmux -2"

    # Test to see if the cron service is already running
    if ! service cron status > /dev/null; then
        # Start cron automatically to run any scheduled jobs
        sudo /etc/init.d/cron start
    fi
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
