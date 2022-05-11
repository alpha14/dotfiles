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

# /!\ Need testing, disabled for now
# Laptop with nvidia card (Optimus)
# You need to see both Intel and NVIDIA with lspci -vnn | egrep 'VGA|3D'
if [[ "${_IS_LAPTOP}" = true && true = false ]]; then
    # https://doc.ubuntu-fr.org/bumblebee#installation
    apt install bbswitch-dkms -y
    modprobe bbswitch
    echo "bbswitch" > /etc/modules
    echo "options bbswitch load_state=0" | tee /etc/modprobe.d/bbswitch.conf
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

apt install terminator zsh keychain htop emacs golang whois dnsutils youtube-dl snapd traceroute build-essential imagemagick -y

if [[ "${_IS_WINDOWS}" = false ]]; then
    apt install steam nextcloud-desktop firefox keepassxc -y
    snap install signal-desktop spotify
fi

update-initramfs -u -v

# https://fwupd.org/lvfs/devices/
fwupdmgr refresh
fwupdmgr update

# Set term to use ZFS by default
#chsh -s /bin/zsh
