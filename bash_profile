if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi

export PATH="$HOME/.poetry/bin:$PATH"
source "$HOME/.cargo/env"
