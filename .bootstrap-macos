#!/usr/bin/env bash

# Install Homebrew
if ! hash brew 2>/dev/null; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

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

# Install web applications
brew cask install google-chrome
brew cask install firefox

# Install development tools
brew cask install visual-studio-code
brew cask install iterm2
brew cask install slack
brew cask install insomnia

# Remove outdated versions from the cellar.
brew cleanup

# Install Rust
curl https://sh.rustup.rs -sSf | sh /dev/stdin -y --no-modify-path
source $HOME/.cargo/env
cargo install ripgrep

