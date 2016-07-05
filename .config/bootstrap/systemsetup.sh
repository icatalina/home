#!/bin/sh

sudo sed -i '' '1s/^/\/usr\/local\/opt\/coreutils\/libexec\/gnubin\'$'\n/' /etc/paths

brewApps=(
  "coreutils"
  "bash"
  "cmake"
  "caskroom/cask/brew-cask"
  "diffutils"
  "ed --default-names"
  "file-formula"
  "findutils --with-default-names"
  "gawk"
  "git"
  "gnu-indent --with-default-names"
  "gnu-sed --with-default-names"
  "gnu-tar --with-default-names"
  "gnu-which --with-default-names"
  "gnutls"
  "grep --with-default-names"
  "gzip"
  "jq"
  "homebrew/binary/ngrok2"
  "less"
  "python"
  "python3"
  "node"
  "rsync"
  "ruby"
  "screen"
  "unzip"
  "watch"
  "wdiff --with-gettext"
  "wget"
  "tmux"
  "the_silver_searcher"
  "zsh"
  "vim --with-override-system-vi"
  "reattach-to-user-namespace"
  "neovim/neovim/neovim"
)

casksApps=(
  "bettertouchtool"
  "betterzipql"
  "caffeine"
  "caskroom/versions/firefoxdeveloperedition"
  "caskroom/versions/google-chrome-canary"
  "coteditor"
  "firefox"
  "filezilla"
  "font-hack"
  "google-chrome"
  "imageoptim"
  "iterm2"
  "java"
  "keka"
  "skype"
  "transmission"
  "upm"
  "viber"
  "virtualbox"
  "vlc"
  "vox"
)

# QuickLook Plugins
quickLookPlugins=(
  "qlcolorcode"
  "qlimagesize"
  "qlmarkdown"
  "qlprettypatch"
  "qlstephen"
  "quicklook-csv"
  "quicklook-json"
  "webpquicklook"
)

nodePackages=(
  "csslint"
  "eslint"
  "grunt-cli"
  "node-inspector"
  "pure-prompt"
)

gemPackages=(
  "scss_lint"
)

# Check for Homebrew,
# Install if we don't have it

if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  echo "Brew already Installed..."
fi

echo "Taping a few things..."
brew tap homebrew/versions
brew tap caskroom/cask/brew-cask
brew tap caskroom/fonts
brew tap homebrew/dupes

# Update homebrew recipes
echo "Updating Formulas..."
brew update

echo "Installing Stuff..."

echo "Installing brew packages..."
for (( i=0; i < ${#brewApps[@]}; i++ ))
do
  print "[%d/%d] Installing %s..." ((i+1)) "${#brewApps[@]}" "${brewApps[$i]}"
  brew install ${brewApps[$i]}
done

echo "Installing Casks..."
brew cask install ${casksApps[@]}

echo "Installing QuickLookPlugins..."
brew cask install ${quickLookPlugins[@]}

echo "Cleaning brew..."
brew cleanup

echo "Installing some node packages..."
npm -g install ${nodePackages[@]}

echo "Installing some Ruby Packages..."
gem install ${gemPackages[@]}
