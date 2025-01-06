#!/bin/bash

# Function to install Homebrew
install_homebrew() {
    echo "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if ! command -v brew &> /dev/null; then
        echo "Homebrew installation failed. Please install it manually and re-run this script."
        exit 1
    fi
    echo "Homebrew installed successfully!"
}

# Ensure Homebrew is installed
if ! command -v brew &> /dev/null; then
    install_homebrew
fi

# Ensure Python and Pip are installed via Homebrew
echo "Installing Python and Pip via Homebrew..."
brew install python

# Install Ansible globally via Homebrew
echo "Installing Ansible globally via Homebrew..."
brew install ansible || true  # Continue even if there are link conflicts

# Resolve potential linking conflicts for Ansible
if [ -f /opt/homebrew/bin/ansible ]; then
    echo "Resolving Homebrew link conflicts for Ansible..."
    brew link --overwrite ansible
fi

# Verify Ansible installation
if ! command -v ansible &> /dev/null; then
    echo "Ansible installation failed. Check your Homebrew setup."
    exit 1
fi

# Install required Ansible Galaxy roles and collections
echo "Installing Ansible Galaxy roles and collections..."
ansible-galaxy install -r playbooks/macos_setup/requirements.yml

# Run the macOS playbook
echo "Running macOS setup playbook..."
ansible-playbook playbooks/macos_setup/playbook.yml -K
