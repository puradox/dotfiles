# Detect OS
PLATFORM=$(uname)

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

if [[ $PLATFORM == "Darwin" ]]; then

  # Homebrew
  eval "$(/opt/homebrew/bin/brew shellenv)"

  # Case-insensitive globbing (used in pathname expansion)
  shopt -s nocaseglob;

  # Append to the Bash history file, rather than overwriting it
  shopt -s histappend;

  # Autocorrect typos in path names when using `cd`
  shopt -s cdspell;

  # Add tab completion for `defaults read|write NSGlobalDomain`
  # You could just use `-g` instead, but I like being explicit
  complete -W "NSGlobalDomain" defaults;

fi

# Enable programmable completion features
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
  . /etc/bash_completion
fi

# Configure nvm (Node.js verson manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# fzf - Command line fuzzy finder
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_COMMAND='rg --files --glob "!{.git,node_modules,bower_components}"'

# Start ssh-agent
SSH_ENV="$HOME/.ssh/env"

function start_agent {
  echo "Initialising new SSH agent..."
  /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
  echo succeeded
  chmod 600 "${SSH_ENV}"
  . "${SSH_ENV}" > /dev/null
  /usr/bin/ssh-add;
}

# Source SSH settings, if applicable
if [ -f "${SSH_ENV}" ]; then
  . "${SSH_ENV}" > /dev/null
  #ps ${SSH_AGENT_PID} doesn't work under cywgin
  ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
    start_agent;
  }
else
  start_agent;
fi

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"

if [ -d ~/fuchsia ]; then
  # Fuchsia
  source ~/fuchsia/scripts/fx-env.sh
fi

# Rust
. "$HOME/.cargo/env"

# Python
eval "$(register-python-argcomplete pipx)"

# Starship bash prompt
eval "$(starship init bash)"
