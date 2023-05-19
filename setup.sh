#! /usr/bin/env bash

# variables
APT_PACKAGES=(python3-pip vim podman docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin)
ARCHITECTURE=$(dpkg --print-architecture)
REQUIREMENTS=(apt-transport-https ca-certificates curl gnupg2 software-properties-common)
UBUNTU_VERSION=$(. /etc/os-release && echo $VERSION_CODENAME)
USERNAME=phrmendes

# update system
apt update && apt upgrade -y
apt autoremove -y

# create user
useradd -m $USERNAME
passwd $USERNAME
usermod -aG sudo $USERNAME
usermod --shell /bin/zsh $USERNAME

# change user
su - $USERNAME

# install requirements
sudo apt install -y "${REQUIREMENTS[@]}"

# install docker
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch=$ARCHITECTURE signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $UBUNTU_VERSION stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
sudo usermod -aG docker "$USERNAME"

# install dependencies
sudo apt install -y "${APT_PACKAGES[@]}"

# zsh theme
omz theme set robbyrussell

# add local bin to path
echo "export PATH=$PATH:$HOME/.local/bin" >>"$HOME/.zshrc"
source "$HOME/.zshrc"

# remove ssh root login
sudo sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config

# free 53 port
sudo sed -i 's/#DNSStubListener=yes/DNSStubListener=no/g' /etc/systemd/resolved.conf
sudo ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf
