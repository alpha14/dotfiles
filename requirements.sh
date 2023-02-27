#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Install deps for debian based distros
apt install laptop-detect software-properties-common -y

_IS_LAPTOP=false
if laptop-detect; then
    _IS_LAPTOP=true
    echo "Detected Laptop configuration"
fi

_IS_WINDOWS=false
if grep -q Microsoft /proc/version; then
    _IS_WINDOWS=true
    echo "Detected Windows operationg system"
fi

_DISTRO=$(awk -F= '/^ID=/{print $2}' /etc/os-release)
echo "Detected linux distro : $_DISTRO"

echo "Adding extra repositories"

# Debian specific
if [[ "${_DISTRO}" == "debian" ]]; then
    apt-add-repository non-free
    apt-add-repository contriub
fi

# Ubuntu specific
if [[ "${_DISTRO}" == "ubuntu" ]]; then
    apt-add-repository multiverse
fi

echo "Installing packages"

# Ubuntu & laptop specific
if [[ ("${_IS_LAPTOP}" = true && "${_DISTRO}" == "ubuntu") ]]; then
    echo "laptop & distro"
    add-apt-repository ppa:slimbook/slimbook -y
    apt update && apt install slimbookbattery -y
else
    apt update
fi

apt install snapd terminator zsh keychain htop emacs golang whois dnsutils snapd traceroute build-essential imagemagick bpython git curl -y

if [[ "${_IS_WINDOWS}" = false ]]; then
    apt install nextcloud-desktop keepassxc python3-pip iftop iotop powertop -y
    snap install firefox signal-desktop spotify onlyoffice-desktopeditors mattermost-desktop
    snap install go --classic

    # Pyenv deps
    apt install build-essential libssl-dev zlib1g-dev \
         libbz2-dev libreadline-dev libsqlite3-dev curl \
         libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
         libffi-dev liblzma-dev libpq-dev ffmpeg -y

    pip install --user poetry yt-dlp

    if [[ ("${_DISTRO}" == "ubuntu") ]]; then
        apt install ubuntu-restricted-extras -y
    fi

    # Gnome settings
    settings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'

    # No snap auto-updates, we want to control when updates are installed
    snap refresh --hold=forever
fi

update-initramfs -u -v

# https://fwupd.org/lvfs/devices/
fwupdmgr refresh
fwupdmgr update

echo "Set term to use ZFS by default, run in your terminal:"
echo "chsh -s /bin/zsh"
echo
echo "end of install script"
