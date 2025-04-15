#!/usr/bin/env bash

if ! which git &>/dev/null; then
    echo "git package is required for this script"
    exit 1
fi

if ! which curl &>/dev/null; then
    echo "curl package is required for this script"
    exit 1
fi

cd "$(dirname "${BASH_SOURCE}")";

if ! git pull origin master; then
    exit 2
fi

function doIt() {

    TMPDIR="${TMPDIR:-$(dirname $(mktemp))}"

    rsync --exclude ".git/" \
          --exclude "bootstrap.sh" \
          --exclude "requirements.sh" \
          --exclude "README.md" \
          -avh --no-perms . ~;

    if [[ ! -d "${HOME}/.oh-my-zsh/" ]]; then
        echo "installing oh-my-zsh"
        git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git ${HOME}/.oh-my-zsh
    else
        cd "${HOME}/.oh-my-zsh" && git pull --rebase
    fi
    # ZSH plugin
    _ZSH_SYNTAX=${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    if [[ ! -d "${_ZSH_SYNTAX}" ]]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${_ZSH_SYNTAX}
    fi

    if [[ ! -d "${HOME}/.vim_runtime/" ]]; then
        echo "installing vimrc"
        git clone --depth=1 https://github.com/amix/vimrc.git ${HOME}/.vim_runtime
        sh ${HOME}/.vim_runtime/install_awesome_vimrc.sh""
    else
        cd "${HOME}/.vim_runtime" && git pull --rebase
    fi

    if [[ ! -d "${HOME}/.nvm/" ]]; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
        source ~/.exports
        nvm install --lts
    fi

    if [[ ! -d "${HOME}/.pyenv/" ]]; then
        curl -o- https://pyenv.run | bash
    fi

    # Linux brew, needs sudo
    if [[ ! -d "/home/linuxbrew/.linuxbrew/" ]]; then
        curl -o- https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
    fi

    # install fonts
    if [[ ! -d "${TMPDIR}/fonts" ]]; then
        git clone https://github.com/powerline/fonts ${TMPDIR}/fonts && ${TMPDIR}/fonts/install.sh
    fi
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
