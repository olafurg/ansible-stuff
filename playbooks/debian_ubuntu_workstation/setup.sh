#!/bin/bash
set -e  # Exit on error
set -u  # Exit on undefined variable

# Upgrade the system
sudo apt update && sudo apt upgrade -y

# Install prerequisites if not already installed
if ! command -v git &> /dev/null; then
    echo "Installing git..."
    sudo apt -y install git
fi

if ! command -v curl &> /dev/null; then
    echo "Installing curl..."
    sudo apt -y install curl
fi

if ! command -v ansible &> /dev/null; then
    echo "Installing ansible..."
    sudo apt -y install ansible
else
    echo "Ansible is already installed."
fi

# Run the playbook
ansible-playbook playbooks/debian_ubuntu_workstation/playbook.yml -K
