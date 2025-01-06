#!/bin/bash

# Set up a virtual environment
if [ ! -d ~/ansible-env ]; then
    echo "Creating a virtual environment for Ansible..."
    python3 -m venv ~/ansible-env
fi

# Activate the virtual environment
source ~/ansible-env/bin/activate

# Upgrade pip and install Ansible
pip install --upgrade pip
pip install --upgrade ansible

# Install required Ansible Galaxy roles and collections
echo "Installing Ansible Galaxy roles and collections..."
ansible-galaxy install -r playbooks/macos_setup/requirements.yml

# Run the macOS playbook
echo "Running macOS setup playbook..."
ansible-playbook playbooks/macos_setup/playbook.yml -i inventories/inventory.yml

ansible-playbook playbooks/macos_setup/playbook.yml -K
