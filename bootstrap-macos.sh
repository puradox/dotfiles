#!/usr/bin/env bash

# Lower key repeat
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 2

# Install Homebrew
if ! hash brew 2>/dev/null; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install Python
brew install pipx
pipx ensurepath

# Install Neovim
brew install neovim

# Install other useful binaries.
brew install git
brew install stow
brew install tmux

# Install the Go programming language
brew install go
brew install hg
brew install bzr
mkdir $HOME/go

# Desktop utilities
brew install --cask rectangle # window snapping
brew install --cask hyperkey  # rebind caps lock

# Install web applications
brew install --cask google-chrome

# Install development tools
brew install --cask visual-studio-code
brew install --cask wezterm

# Remove outdated versions from the cellar.
brew cleanup

# Install Rust
curl https://sh.rustup.rs -sSf | sh /dev/stdin -y --no-modify-path
source $HOME/.cargo/env
cargo install ripgrep

