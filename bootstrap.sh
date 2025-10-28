#!/usr/bin/env bash
set -x

# Ask for the administrator password upfront
sudo -v

cd "$(dirname "${BASH_SOURCE}")";

git pull origin master;

function doIt() {
  PLATFORM=$(uname)
  echo "Detected $PLATFORM"

  # Install the platform dependant things
  if [[ $PLATFORM == "Linux" ]]; then
    sudo bash bootstrap-linux.sh
    stow -v -t ${HOME} hyprland
    stow -v -t ${HOME} kanshi
    stow -v -t ${HOME} kitty
    stow -v -t ${HOME} starship
    stow -v -t ${HOME} sway
    stow -v -t ${HOME} zellij
  elif [[ $PLATFORM == "Darwin" ]]; then
    ./bootstrap-macos.sh
    stow -v -t ${HOME} iterm2
  fi

  # Symlink the dotfiles to the home directory.
  stow -v -t ${HOME} bash
  stow -v -t ${HOME} editorconfig
  stow -v -t ${HOME} gdb
  stow -v -t ${HOME} git
  stow -v -t ${HOME} vim
  stow -v -t ${HOME} vscode

  source ~/.bash_profile;

  # Install Rust
  curl https://sh.rustup.rs -sSf | sh /dev/stdin -y --no-modify-path
  source $HOME/.cargo/env

  # Install Rust binaries
  cargo install ripgrep
  cargo install --locked starship zellij

  # Install vim-plug
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  nvim +PlugInstall +qall
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
  doIt;
else
  read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
  echo "";
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    doIt;
  fi;
fi;
unset doIt;
