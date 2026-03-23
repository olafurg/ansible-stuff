#!/bin/bash

# Upgrade the system
sudo apt update && sudo apt upgrade -y

# Install prerequisites
sudo apt -y install git curl ansible

# Run the playbook
ansible-playbook playbooks/debian_ubuntu_wsl/playbook.yml -K
