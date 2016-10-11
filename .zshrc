test -e "$HOME/.config/zsh/zshrc" && source "$HOME/.config/zsh/zshrc"
test -e "$HOME/.local/zshrc"      && source "$HOME/.local/zshrc"

test -e "$HOME/.config/sourcefile" && source "$HOME/.config/sourcefile"
test -e "$HOME/.local/sourcefile"  && source "$HOME/.local/sourcefile"

test -e "$HOME/.config/alias" && source "$HOME/.config/alias"
test -e "$HOME/.local/alias"  && source "$HOME/.local/alias"
