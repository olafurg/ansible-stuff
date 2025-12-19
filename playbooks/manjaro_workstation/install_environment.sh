#!/bin/sh

# Update pacman.
sudo pacman -Syu

# Install Ansible.
sudo pacman -S ansible --noconfirm

# Add localhost to Ansible hosts list.
echo "localhost" | sudo tee -a /etc/ansible/hosts

# Run the top-level Ansible playbook.
ansible-playbook main.yml -K
