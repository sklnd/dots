# If not running interactively, don't do anything
[ -z "$PS1" ] && return

Color_Off='\e[0m'       # Text Reset

# Regular Colors
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White

# Bold
BBlack='\e[1;30m'       # Black
BRed='\e[1;31m'         # Red
BGreen='\e[1;32m'       # Green
BYellow='\e[1;33m'      # Yellow
BBlue='\e[1;34m'        # Blue
BPurple='\e[1;35m'      # Purple
BCyan='\e[1;36m'        # Cyan
BWhite='\e[1;37m'       # White

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
    export ENV="[$1] "
  else
    echo "No such environment: $1"
  fi
}

#source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi


# Start building up $PS1
P="\w\n"                                  # working dir + newline
P+="\[\e[$(ps1_color)m\]<\u@\h>\[\e[0m\]" # <user@host>

# Make bash completion work with git
if [ -f /etc/bash_completion.d/git ]; then
  source /etc/bash_completion.d/git
  P+="\[${Red}\]\$(__git_ps1)\[${Color_Off}\] "  # (git_branch)
elif [ -f /usr/lib/git-core/git-sh-prompt ]; then
  source /usr/lib/git-core/git-sh-prompt
  P+="\[${Red}\]\$(__git_ps1)\[${Color_Off}\] "  # (git_branch)
fi

P+="\[${Green}\]\$ENV\[${Color_Off}\]" # [env]
P+="\$ "
export PS1=$P

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

# add local bin items
if [ -d ~/.local/bin ]; then
    PATH=~/.local/bin:"${PATH}"
fi

# I am a terrible lazy person
export PATH="$PATH:."
