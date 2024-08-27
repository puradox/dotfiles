#!/usr/bin/env bash

# Upgrade latest packages
apt update
apt full-upgrade --yes

# Install Neovim
if ! hash nvim 2>/dev/null; then
  apt update
  apt install neovim python3-dev python3-pip python3-neovim xsel

  # Set Neovim to default editor
  update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
  update-alternatives --auto vi
  update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
  update-alternatives --auto vim
  update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
  update-alternatives --auto editor
fi

# Install other useful binaries.
apt install git
apt install stow
apt install tmux
apt install wget
apt install fd-find

# Install Rust
curl https://sh.rustup.rs -sSf | sh /dev/stdin -y --no-modify-path
source $HOME/.cargo/env
cargo install ripgrep
