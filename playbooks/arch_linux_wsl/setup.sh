#!/bin/bash

# Upgrade the system
sudo pacman -Syu

# Install prerequisites
sudo pacman -S --needed git curl ansible

# Run the playbook with locale set
LANG=C.UTF-8 LC_ALL=C.UTF-8 ansible-playbook playbooks/arch_linux_wsl/playbook.yml -K
