#! /usr/bin/env bash

# variables
USERNAME=phrmendes
APT_PACKAGES=(python3-pip vim podman uidmap slirp4netns)
PYTHON_PACKAGES=(podman-compose)
CWD=$(pwd)

# update system
apt update && apt upgrade -y
apt autoremove -y

# create user
useradd -m $USERNAME
passwd $USERNAME
usermod -aG sudo $USERNAME
usermod --shell /bin/zsh $USERNAME

# install dependencies
apt install -y "${APT_PACKAGES[@]}"

# change user
su - $USERNAME

# zsh theme
omz theme set robbyrussell

# install podman-compose
pip3 install "${PYTHON_PACKAGES[@]}"

# add local bin to path
echo "export PATH=$PATH:$HOME/.local/bin" >>"$HOME/.zshrc"
source "$HOME/.zshrc"

# remove ssh root login
sudo sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config

# podman-compose in home directory
ls -s "$CWD/podman-compose" "$HOME/podman-compose.yml"
