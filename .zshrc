export ZSH="${HOME}/.oh-my-zsh"

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="agnoster"

setopt EXTENDED_HISTORY
setopt SHARE_HISTORY

autoload zmv
autoload predict-on

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="false"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(git zsh-syntax-highlighting systemd history-substring-search cp colorize)

REPORTTIME=1

source "${ZSH}/oh-my-zsh.sh"

# Aliases
# * ~/.personal and ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,personal,exports,aliases,functions,extra}; do
    [ -f "$file" ] && [ -r "$file" ] && source "$file";
done;
unset file;

