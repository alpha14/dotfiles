#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

CURRENT_USER="root"
if [[ "${SUDO_USER}" != "" ]]; then
    CURRENT_USER="${SUDO_USER}"
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
    add-apt-repository non-free
    add-apt-repository contriub
fi

# Ubuntu specific
if [[ "${_DISTRO}" == "ubuntu" ]]; then
    add-apt-repository multiverse -y
    add-apt-repository ppa:cappelikan/ppa -y
fi

echo "Installing packages"

# Ubuntu & laptop specific
if [[ ("${_IS_LAPTOP}" = true && "${_DISTRO}" == "ubuntu") ]]; then
    echo "laptop & distro"
    apt remove power-profiles-daemon -y
    add-apt-repository ppa:slimbook/slimbook -y
    apt update && apt install slimbookbattery -y
else
    apt update
fi

apt install python3-pip snapd tlp terminator zsh keychain htop emacs whois dnsutils snapd traceroute build-essential imagemagick bpython git curl acpi-call-dkms tree moreutils xclip -y

# Pyenv deps
apt install build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev curl \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
    libffi-dev liblzma-dev libpq-dev -y


runuser "${CURRENT_USER}" pip install --user poetry yt-dlp
snap install go --classic

# No snap auto-updates, we want to control when updates are installed
snap refresh --hold=forever

if [[ "${_IS_WINDOWS}" == true ]]; then
    exit 0
fi

apt install nextcloud-desktop keepassxc iftop iotop powertop ffmpeg -y
snap install firefox signal-desktop spotify onlyoffice-desktopeditors mattermost-desktop

if [[ ("${_DISTRO}" == "ubuntu") ]]; then
    apt install ubuntu-restricted-extras mainline -y
fi

# Gnome settings
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'
gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.desktop.interface enable-animations false

# https://fwupd.org/lvfs/devices/
fwupdmgr refresh
fwupdmgr update

# To trigger if:
# - An updated kernel is installed
# - If you have third-party kernel modules added/removed (drivers)
# - The scripts responsible for creating the actual initramfs contents, or the configuration files for those scripts, are changed
# - Any persistent settings related to the root filesystem, primary swap and/or resuming from hibernation are changed
update-initramfs -u

echo "Set term to use ZFS by default, run in your terminal:"
echo "chsh -s /bin/zsh"
echo
echo "end of install script"
