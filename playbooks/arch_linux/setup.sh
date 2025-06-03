#!/bin/bash

# Upgrade the system
sudo pacman -Syu

# Install prerequisites
sudo pacman -S --needed git curl ansible

# Setup locale if none is set
if [ ! -f /etc/locale.conf ] || [ -z "$(grep '^LANG=' /etc/locale.conf)" ]; then
    echo "No locale configured, setting up default locale..."
    echo "en_US.UTF-8 UTF-8" | sudo tee /etc/locale.gen
    sudo locale-gen
    echo "LANG=en_US.UTF-8" | sudo tee /etc/locale.conf
    echo "LC_ALL=en_US.UTF-8" | sudo tee -a /etc/locale.conf
fi

# Run the playbook with locale set
LANG=C.UTF-8 LC_ALL=C.UTF-8 ansible-playbook playbooks/arch_linux/playbook.yml -K
