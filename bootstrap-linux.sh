#!/usr/bin/env bash
set -x

# Install Python
sudo apt update
sudo apt install pipx
pipx ensurepath

# Install Python packages
pipx install rofimoji

# Install Neovim
if ! hash nvim 2>/dev/null; then
  sudo apt update
  sudo apt install neovim python3-dev python3-pip python3-neovim xsel

  # Set Neovim to default editor
  sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
  sudo update-alternatives --auto vi
  sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
  sudo update-alternatives --auto vim
  sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
  sudo update-alternatives --auto editor
fi

# Install other useful binaries.
sudo apt install git
sudo apt install stow
sudo apt install tmux
sudo apt install wget
sudo apt install fd-find
sudo apt install xdotool

# Install kitty terminal
mkdir -p $HOME/.local/stow
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin \
  dest=$HOME/.local/stow
stow -v -t $HOME/.local -d $HOME/.local/stow kitty.app
xdg-mime default org.kde.dolphin.desktop inode/directory

# Install gLinux-specific packages and config
if [[ `uname -n` =~ corp.google.com|c.googlers.com ]]; then
  sudo bash bootstrap-glinux.sh
fi

