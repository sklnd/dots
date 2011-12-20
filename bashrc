export LC_ALL=C

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
  export PS1="\[\e[32m\]<\u@\h>\[\e[0m\] \w\[\e[31m\]\$(__git_ps1)\[\e[0m\] \$ "
else
  export PS1="\[\e[32m\]<\u@\h>\[\e[0m\] \w\[\e[31m\]\[\e[0m\] \$ "
fi

# Aliases
alias ls="ls --color"

# I am a terrible lazy person
export PATH="$PATH:."
