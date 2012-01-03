# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Create a PS1 color based on the hostname
function ps1_color() {
  HOST_HASH=$(hostname | sha1sum | awk '{print $1 }')
  HOST_HASH=$(echo $HOST_HASH | tr '[:lower:]' '[:upper:]')
  HASH_DEC=$(expr $(echo ${HOST_HASH:0:2} p | dc) % 100)
  PS1_BRIGHT=$(expr ${HASH_DEC:0:1} % 2)
  let "PS1_COLOR=HASH_DEC % 6 + 31"
  echo "$PS1_BRIGHT;$PS1_COLOR"
}

export LC_ALL=C

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# e will source a specific build environment script stored in .env
e () {
  if [ -f ~/.env/$1 ]; then
    . ~/.env/$1
  else
    echo "No such environment: $1"
  fi
}

#source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi


# Make bash completion work with git
if [ -f /etc/bash_completion.d/git ]; then
  source /etc/bash_completion.d/git
  export PS1="\[\e[$(ps1_color)m\]<\u@\h>\[\e[0m\] \w\[\e[31m\]\$(__git_ps1)\[\e[0m\] \$ "
else
  export PS1="\[\e[$(ps1_color)m\]<\u@\h>\[\e[0m\] \w\[\e[31m\]\[\e[0m\] \$ "
fi

# Aliases
alias g="ack-grep"

# Enable colors support in LS
if [ "$TERM" != "dumb" ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
fi

# set PATH so it includes user's private bin if it exists
if [ -d ~/bin ]; then
    PATH=~/bin:"${PATH}"
fi

# I am a terrible lazy person
export PATH="$PATH:."
