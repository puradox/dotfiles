Sam’s dotfiles
==============
 > My personal modifications to Mathias Bynens' [dotfiles](https://github.com/mathiasbynens/dotfiles)

## Notable changes
 - Supports both Mac and Linux
 - Striped down the amount of *'sensible'* defaults to only the bare essentials
 - Install and update right from the get-go
 - :innocent: spaces > tabs

## Installation

**Warning:** If you want to give these dotfiles a try, you should first fork this repository, review the code, and remove things you don’t want or need. Don’t blindly use my settings unless you know what that entails. Use at your own risk!

### Using Git and the bootstrap script

You can clone the repository wherever you want (I keep it in `~/Dev/dotfiles`). The bootstrapper script will pull in the latest version and copy the files to your home folder.

```bash
  git clone https://github.com/puradox/dotfiles.git && cd dotfiles && source bootstrap.sh
```

To update, `cd` into your local `dotfiles` repository and then:

```bash
  source bootstrap.sh
```

Alternatively, to update while avoiding the confirmation prompt:

```bash
  set -- -f; source bootstrap.sh
```

### Git-free install

To install these dotfiles without Git:

```bash
  cd; curl -#L https://github.com/puradox/dotfiles/tarball/master \
    | tar -xzv --strip-components 1 --exclude={README.md,bootstrap.sh,.osx,LICENSE-MIT.txt}
```

To update later on, just run that command again.

### Specify the `$PATH`

If `~/.path` exists, it will be sourced along with the other files, before any feature testing (such as [detecting which version of `ls` is being used](https://github.com/puradox/dotfiles/blob/aff769fd75225d8f2e481185a71d5e05b76002dc/.aliases#L21-26)) takes place.

Here’s an example `~/.path` file that adds `/usr/local/bin` to the `$PATH`:

```bash
  export PATH="/usr/local/bin:$PATH"
```

### Add custom commands without creating a new fork

If `~/.extra` exists, it will be sourced along with the other files. You can use this to add a few custom commands without the need to fork this entire repository, or to add commands you don’t want to commit to a public repository.

My `~/.extra` looks something like this:

```bash
  #!/usr/bin/env bash

  # Git credentials
  # Not in the repository, to prevent people from accidentally committing under my name
  GIT_AUTHOR_NAME="Sam Balana"
  GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
  git config --global user.name "$GIT_AUTHOR_NAME"
  GIT_AUTHOR_EMAIL="me@sambalana.com"
  GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
  git config --global user.email "$GIT_AUTHOR_EMAIL"
```

You could also use `~/.extra` to override settings, functions and aliases from my dotfiles repository. It’s probably better to [fork this repository](https://github.com/puradox/dotfiles/fork) instead, though.

### Sensible Mac defaults

When setting up a new Mac, you may want to set some sensible macOS defaults:

```bash
  ./.macos
```

## Feedback

Suggestions or improvements are
[welcome](https://github.com/puradox/dotfiles/issues)!
