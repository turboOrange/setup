#!/bin/bash

set -e

echo "Updating and upgrading system..."
sudo apt update && sudo apt upgrade -y

echo "Installing KDE Plasma Desktop..."
sudo apt install -y kde-plasma-desktop sddm

echo "Installing tiling extension for KDE..."
# Bismuth: KDE tiling extension
plasma_version=$(plasmashell --version 2>/dev/null | grep -oP '[0-9]+\.[0-9]+')
if [ -n "$plasma_version" ]; then
    echo "Installing Bismuth for KDE Plasma..."
    sudo apt install -y git
    git clone https://github.com/Bismuth-Forge/bismuth.git
    cd bismuth
    ./install.sh
    cd ..
fi

echo "Installing terminal and tools..."
sudo apt install -y alacritty tmux

echo "Installing browsers..."
sudo apt install -y firefox-esr chromium

echo "Installing VS Code..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | \
    sudo tee /etc/apt/sources.list.d/vscode.list
sudo apt update
sudo apt install -y code

echo "Installing speedcrunch..."
sudo apt install -y speedcrunch

echo "Installing programming languages and dev tools..."
sudo apt install -y \
    build-essential cmake gdb valgrind \
    python3 python3-pip python3-venv \
    openjdk-17-jdk \
    nodejs npm \
    rustc cargo \
    elixir

echo "Installing Docker & Podman..."
sudo apt install -y docker.io docker-compose podman
sudo usermod -aG docker $USER
newgrp docker

echo "Installing Kubernetes (kubectl & minikube)..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl

curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64

echo "Installing Terraform..."
sudo apt install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt install -y terraform

echo "Installing VirtualBox..."
sudo apt install -y virtualbox virtualbox-ext-pack

echo "Installing office apps..."
sudo apt install -y libreoffice

echo "Installing OnlyOffice (AppImage)..."
mkdir -p ~/Apps && cd ~/Apps
wget https://download.onlyoffice.com/install/desktop/editors/linux/onlyoffice-desktopeditors_amd64.deb
sudo apt install -y ./onlyoffice-desktopeditors_amd64.deb
cd ~

echo "Installing developer tools..."
sudo apt install -y mitmproxy wireshark dbeaver postman dolphin

echo "Installing GraphUI and Draw.io..."
flatpak install -y flathub io.github.fabiensanglard.GraphUI
flatpak install -y flathub com.jgraph.drawio.desktop

echo "Enabling Flatpak integration..."
sudo apt install -y flatpak gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "Setup Complete!"
