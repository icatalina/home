test -e "$HOME/.config/zsh/bashprofile" && source "$HOME/.config/zsh/bashprofile"
test -e "$HOME/.local/bashprofile"      && source "$HOME/.local/bashprofile"

test -e "$HOME/.config/sourcefile" && source "$HOME/.config/sourcefile"
test -e "$HOME/.local/sourcefile"  && source "$HOME/.local/sourcefile"

test -e "$HOME/.config/alias" && source "$HOME/.config/alias"
test -e "$HOME/.local/alias"  && source "$HOME/.local/alias"
shopt -s histappend
shopt -s cmdhist
HISTFILESIZE=1000000
HISTSIZE=1000000
HISTCONTROL=ignoreboth:erasedups
HISTIGNORE='ls:clear:bg:fg:history:exit:pwd:cd\ ..:ll:ls\ *:history\ *'
HISTFILE=~/.local/tmp/bash_history
PROMPT_COMMAND='history -a'
