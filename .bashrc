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

## Colors?  Used for the prompt.
#Regular text color
BLACK='\[\e[0;30m\]'
#Bold text color
BBLACK='\[\e[1;30m\]'
#background color
BGBLACK='\[\e[40m\]'
RED='\[\e[0;31m\]'
BRED='\[\e[1;31m\]'
BGRED='\[\e[41m\]'
GREEN='\[\e[0;32m\]'
BGREEN='\[\e[1;32m\]'
BGGREEN='\[\e[1;32m\]'
YELLOW='\[\e[0;33m\]'
BYELLOW='\[\e[1;33m\]'
BGYELLOW='\[\e[1;33m\]'
BLUE='\[\e[0;34m\]'
BBLUE='\[\e[1;34m\]'
BGBLUE='\[\e[1;34m\]'
MAGENTA='\[\e[0;35m\]'
BMAGENTA='\[\e[1;35m\]'
BGMAGENTA='\[\e[1;35m\]'
CYAN='\[\e[0;36m\]'
BCYAN='\[\e[1;36m\]'
BGCYAN='\[\e[1;36m\]'
WHITE='\[\e[0;37m\]'
BWHITE='\[\e[1;37m\]'
BGWHITE='\[\e[1;37m\]'
GRAY='\[\e[1;30m\]'
LGRAY='\[\e[0;37m\]'

PROMPT_COMMAND=smile_prompt

function smile_prompt
{
if [ "$?" -eq "0" ]
then
#smiley
SC="${GREEN}:)"
else
#frowney
SC="${RED}:("
fi
if [ $UID -eq 0 ]
then
#root user color
UC="${RED}"
else
#normal user color
UC="${LGRAY}"
fi
#hostname color
HC="${BCYAN}"
#time color
TC="${BMAGENTA}"
#regular color
RC="${BGREEN}"
#default color
DF='\[\e[0m\]'
PS1="${DF}|${TC}\t${DF}|${UC}\u${DF}@${HC}\h ${RC}[\W] ${SC}${DF} "
}

# Always start tmux on a new session
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux new-session -A -s main
fi

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
alias whence='type -a'                        # where, of a sort

# Some shortcuts for different directory listings
alias ls='ls -hF --color=tty'                 # classify files in colour
alias dir='ls --color=auto --format=vertical'
alias vdir='ls --color=auto --format=long'
alias ll='ls -al'                              # long list
alias la='ls -A'                              # all but . and ..
alias l='ls -CF'                              #

# if .bash_local exist, source it.
# .bash_local can be used to set machine-specific settings
# that isn't synced to Git
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bash_local" ]; then
    . "$HOME/.bash_local"
    fi
fi

# User defined aliases

alias sshs='ssh qwertyshoe.com'
alias sshb='ssh bastion.admin.nextgatecloud.com'

export TERM=xterm-256color
alias tmux="tmux -2"

# Functions
# #########

# Some example functions
# function settitle() { echo -ne "\e]2;$@\a\e]1;$@\a"; }

# Function to update vimrc and then connect to aws server.
# Auto completion provided by function in .bash_completion
sshaws() {
    uvimrc $1
    ssha $1
}

