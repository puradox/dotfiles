#!/usr/bin/env bash

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
    stow -t ${HOME} hyprland
  elif [[ $PLATFORM == "Darwin" ]]; then
    ./bootstrap-macos.sh
    stow -t ${HOME} iterm2
  fi

  # Symlink the dotfiles to the home directory.
  stow -t ${HOME} bash
  stow -t ${HOME} editorconfig
  stow -t ${HOME} gdb
  stow -t ${HOME} git
  #stow -t ${HOME} kak
  stow -t ${HOME} tmux
  stow -t ${HOME} vim
  stow -t ${HOME} vscode

  source ~/.bash_profile;

  # Install Rust binaries
  cargo install ripgrep
  cargo install starship --locked

  # Install kitty terminal
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

  # Install Python packages
  pipx install rofimoji

  # Install Tmux Plugin Manager
  ~/.tmux/plugins/tpm/bin/install_plugins

  # Install vim-plug
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  nvim +PlugInstall +qall

  # Install and load nvm (Node.js version manager)
  #curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
  #export NVM_DIR="$HOME/.nvm"
  #[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

  # Install the latest version of node
  #nvm install node
  #nvm use node
  #nvm alias default node
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
