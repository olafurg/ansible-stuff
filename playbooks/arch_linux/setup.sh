#!/bin/bash

# Upgrade the system
sudo pacman -Syu

# Install prerequisites
sudo pacman -S git curl ansible

# Run the playbook
ansible-playbook playbooks/arch_linux/playbook.yml -K
