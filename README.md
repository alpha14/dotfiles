# Alpha14’s dotfiles

Compatible with GNU/linux and macos, it tweaks bash and zsh and adds aliases.
I try to keep aliases shell/OS agnostic.

## Installation

**Warning:** If you want to give these dotfiles a try, you should first fork this repository, review the code, and remove things you don’t want or need. Use at your own risk!

While it does install zsh plugins, it does not change your default shell. (Use chsh -s /usr/bin/zsh)
Powerline fonts are also installed with the bootstrap script

### Using the bootstrap script

You can clone the repository wherever you want. The bootstrapper script will pull in the latest version and copy the files to your home folder.

```bash
git clone https://github.com/alpha14/dotfiles.git && cd dotfiles && source bootstrap.sh
```

To update, `cd` into your local `dotfiles` repository and then:

```bash
source bootstrap.sh
```
To update later on, just run that command again.

### Add custom commands/config without creating a new fork

If `~/.personal` or `~/.extra` exists, they will be sourced along with the other files. You can use this to add a few custom commands without the need to fork this entire repository, or to add commands you don’t want to commit to a public repository.

My `~/.personal` looks something like this:

```bash
# Git credentials
# Not in the repository, to prevent people from accidentally committing under my name
GIT_AUTHOR_NAME="John Doe"
GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
git config --global user.name "$GIT_AUTHOR_NAME"
GIT_AUTHOR_EMAIL="john.doe@example.com"
GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
git config --global user.email "$GIT_AUTHOR_EMAIL"

export SSH_KEYS=('mykey 1' 'mykey 2')
```

You could also use `~/.personal` or `~/.extra` to override settings, functions and aliases from the dotfiles repository.
My extra contains work related aliases.

### Exports

Please read carefully the .exports file, you can modifiy the EDITOR (emacs by default) and the LANG there


### Extra git config

For every repos located in ~/work, I have an additionnal git config located in ~/.gitconfig-work that looks like this:
```
[user]
name = John Doe
email = john.doe@work.example.com
```

### SSH keys
If you have the keychain utility, you can set the SSH_KEYS variable containing a list of keys you want to autoload. Otherwise, every ssh key in ~/.ssh will loaded in the ssh-agent

### Todo
Automate requirements installation

Remove too specific commands/aliases

## Feedback

Suggestions/improvements
[welcome](https://github.com/alpha14/dotfiles/issues)!

## Thanks to…

* [Mathias Bynens] and his [dotfiles repository](https://github.com/mathiasbynens/dotfiles)
* [Atomantic] and his [dotfiles repository](https://github.com/atomantic/dotfiles)