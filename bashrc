# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

### DEFAULT CONFIGURATION ###

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# If running on tty1, start sway
if [ $(tty) = '/dev/tty1' ]; then
    /usr/bin/start-sway
fi

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# bash-completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

### PROMPT SETTINGS ###
# prompt settings would go here, but I'm using starship.


### PATH ###

# include ~/bin
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# include ~/.local/bin
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# firefox.exe in Windows land
export PATH=$PATH:/mnt/c/Program\ Files/Mozilla\ Firefox

# go
export PATH=$PATH:/usr/local/go/bin:/home/luisp/go/bin

# rust binaries
export PATH=$PATH:/home/luisp/.cargo/bin


### ENVIRONMENT VARIABLES ###

# gpg commit signing
export GPG_TTY=$(tty)

# node version manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# default editor
export EDITOR=nvim


### EXTERNAL CONFIGURATION ###

# cargo env
. "$HOME/.cargo/env"

# proxy settings
. "$HOME/.bash_proxy"


### ALIASES ###

# ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# fuzzy find repos
alias jd='cd $(find ~/dev -mindepth 1 -maxdepth 6 -type d 2>/dev/null | fzf)'

# git aliases
alias gs='git status'
alias gl='git log'

# open current git remote in firefox
alias gof='firefox.exe $(git remote -v | grep -o -E "https://git[^ ]*" | tail -1)'

# maven and gradle run configurations
alias mvn-bootrun='mvn spring-boot:run -Dspring-boot.run.profiles=local -Duser.timezone=Europe/Berlin -Dspring-boot.run.jvmArguments="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=8000"'
alias gradle-bootrun='./gradlew bootRun --args="--spring.profiles.active=dev"'

# Set default kubeconfig path
export KUBECONFIG=~/.kube/config

### PROMPT ###

# launch starship
eval "$(starship init bash)"

