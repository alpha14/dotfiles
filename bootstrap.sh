#!/usr/bin/env bash


cd "$(dirname "${BASH_SOURCE}")";

git pull origin master;

function doIt() {

    TMPDIR="{${TMPDIR:-$(dirname $(mktemp))/}"

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
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

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

    # install fonts
    if [[ ! -d "${TMPDIR}/fonts/" ]]; then
        git clone https://github.com/powerline/fonts ${TMPDIR}/fonts && ${TMPDIR}/fonts/install.sh && rm -rf ${TMPDIR}/fonts
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
