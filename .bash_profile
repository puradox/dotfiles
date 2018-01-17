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

# Configure nvm (Node.js verson manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
