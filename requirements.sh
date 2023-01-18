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
    apt update && sudo apt install slimbookbattery -y
else
    apt update
fi

apt install terminator zsh keychain htop emacs golang whois dnsutils snapd traceroute build-essential imagemagick bpython git curl -y

if [[ "${_IS_WINDOWS}" = false ]]; then
    apt install nextcloud-desktop keepassxc -y
    snap install firefox signal-desktop spotify
fi

update-initramfs -u -v

# https://fwupd.org/lvfs/devices/
fwupdmgr refresh
fwupdmgr update

# Set term to use ZFS by default
#chsh -s /bin/zsh
