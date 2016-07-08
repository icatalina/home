#!/usr/bin/env bash
systemtweaks='~/.config/bootstrap/osxtweaks.sh'

brewTaps=(
  "homebrew/versions"
  "caskroom/cask"
  "caskroom/fonts"
  "homebrew/dupes"
)

brewApps=(
  "coreutils"
  "bash"
  "cmake"
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

caskApps=(
  "bettertouchtool"
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
  "virtualbox"
)

caskAppsPersonal=(
  "skype"
  "transmission"
  "viber"
  "vlc"
  "vox"
)

# QuickLook Plugins
quickLookPlugins=(
  "betterzipql"
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
  "diff-so-fancy"
)

gemPackages=(
  "csslint"
  "eslint"
  "grunt-cli"
  "node-inspector"
  "pure-prompt"
  "diff-so-fancy"
)

gemPackages=(
  "scss_lint"
)

clean="\r\033[K"
barWidth=15
logfilename="$HOME/systemsetup$(date +%s).log"
errorfilename="$HOME/systemsetup$(date +%s).error.log"

function command_exists () {
    which "$1" &> /dev/null ;
}

function ProgressBar {

  let _current=$(($1+1))
  # Process data
  let _progress=(${_current}*100/${2}*100)/100

  let _done=(${_progress}*$barWidth)/100
  let _left=$barWidth-$_done

  # Build progressbar string lengths
  _fill=$(printf "%${_done}s")
  _empty=$(printf "%${_left}s")

  # 1.2 Build progressbar strings and print the ProgressBar line
  # 1.2.1 Output example:
  # 1.2.1.1 Progress : [########################################] 100%
  printf "${clean}[${_fill// /#}${_empty}] %3d%% - [%02d/%02d] Installing $3..." $_progress $_current $2
}

function InstallPackages {
  name=$1[@]
  packages=("${!name}")
  echo ''
  printf '  - %s\n' "${packages[@]}"
  echo ''
  read -n1 -r -p "Proceed? (y/n) " key
  if [[ $key == 'y' ]]; then
    for (( i=0; i < ${#packages[@]}; i++ ))
    do
      ProgressBar $i "${#packages[@]}" "${packages[$i]}"
      $2 ${packages[$i]} >>$logfilename 2>>$errorfilename
    done
  fi
  echo ""
  echo ""
}

read -n1 -r -p "This script will install brew, node and several BREW, CASK, NPM & GEM packages, do you want to continue? (y/n) " key
if [[ $key != 'y' ]]; then
  echo ""
  echo "You can re-run this script using:"
  echo "  ~/.config/bootstrap/packages.sh"
  echo "To modify OSX options:"
  echo "  $systemtweaks"
  exit
fi
echo ''
echo ''

# Check for Homebrew,
# Install if we don't have it
if command_exists brew; then
  echo "Brew already Installed..."
  echo ''
else
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  echo ''

  if ! command_exists brew; then
    echo "ERROR: Seems like BREW failed to install..."
    echo "Check the logs $logfilename and $errorfilename"
    exit 1

  fi
fi

echo "Taping a few things..."
InstallPackages 'brewTaps' 'brew tap'

if ! brew info cask &>/dev/null; then
  echo "ECHO: Failed to install Cask (Homebrew Extension)"
  echo "Check the logs $logfilename and $errorfilename"
  exit 1
fi

# Update homebrew recipes
echo "Updating Formulas..."
brew update

echo "Installing Stuff..."

echo ''
echo "Installing brew packages..."
InstallPackages 'brewApps' 'brew install'

echo "Installing casks..."
InstallPackages 'caskApps' 'brew cask install'

echo "###################"
echo "# PERSONAL APPS!! #"
echo "###################"
echo "Installing personal packages..."
InstallPackages 'caskAppsPersonal' 'brew cask install'

echo "Installing QuickLookPlugins..."
InstallPackages 'quickLookPlugins' 'brew cask install'

echo "Cleaning brew..."
brew cleanup
echo ''

read -n1 -r -p "Do you want to modify /etc/paths so unix packages are prefered? (y/n) " key
if [[ $key == 'y' ]]; then
  sudo sed '' '1s/^/\/usr\/local\/opt\/coreutils\/libexec\/gnubin\n\/usr\/local\/bin\n/' /etc/paths
fi
echo ''
echo ''

if command_exists node && command_exists npm; then
  if command_exists n; then
    echo "N is already available, not installing..."
  else
    echo "Installing n for node version management..."
    npm install -g n
  fi

  echo "Current node version $(node --version)"
  if [[ "$(node --version | sed 's/v//')" == "$(n --lts)" ]]; then
    echo "Already on the latest LTS version available, skipping..."
    echo ''
  else
    echo ''
    read -n1 -r -p "Do you want to install the latest NODE LTS version? (y/n) " key
    if [[ $key == 'y' ]]; then
      echo ''
      echo "Installing latest LTS NODE version..."
      n lts
    fi
    echo ''
  fi

  echo "Installing some NODE Packages..."
  InstallPackages 'nodePackages' 'npm -g install'

else
  echo "NODE or NPM not found, skipping..."
fi

if command_exists ruby && command_exists gem; then
  echo "Installing some Ruby Gems..."
  InstallPackages 'gemPackages' 'gem install'
else
  echo "Ruby or RubyGEM not found, skipping..."
fi

if command_exists python && command_exists pip; then
  read -n1 -r -p "Do you want to update (Python2) pip, setuptools & wheel (y/n) " key
  if [[ $key == 'y' ]]; then
    echo ''
    echo "Updating (Python2) pip, setuptools & wheel"
    pip install --upgrade pip setuptools wheel
  fi
  echo ''
else
  echo "Python not found, skipping..."
fi

if command_exists python3 && command_exists pip3; then
  read -n1 -r -p "Do you want to update (Python3) pip, setuptools & wheel (y/n) " key
  if [[ $key == 'y' ]]; then
    echo ''
    echo "Updating (Python3) pip, setuptools & wheel"
    pip3 install --upgrade pip setuptools wheel
  fi
  echo ''
else
  echo "Python3 not found, skipping..."
fi

echo ""
echo "Finished!"
echo "Check logs for failures:"
echo " - $logfilename"
echo " - $errorfilename"
echo ""
echo "When you're finished, you can remove the logs using:"
echo "  rm ~/systemsetup*.log"
echo ""
eval "$systemtweaks"
