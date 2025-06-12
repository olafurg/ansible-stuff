#!/bin/zsh

# Ensure Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if ! command -v brew &> /dev/null; then
        echo "Homebrew installation failed. Please install it manually and re-run this script."
        exit 1
    fi
fi

# Ensure Python and Pipx are installed via Homebrew
echo "Installing Python and Pipx via Homebrew..."
brew install python pipx

# Ensure Pipx path is added to PATH
echo "Ensuring pipx path is added to PATH..."
pipx ensurepath
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/pipx/venvs/ansible/bin:$PATH"

# Install Ansible via Pipx (skip if already installed)
if ! command -v ansible &> /dev/null; then
    echo "Installing Ansible via Pipx..."
    pipx install ansible
else
    echo "Ansible is already installed. Skipping installation."
fi

# Verify Ansible installation
if ! command -v ansible &> /dev/null; then
    echo "Ansible installation failed. Please check your Pipx setup."
    exit 1
fi

# Install required Ansible Galaxy roles and collections
echo "Installing Ansible Galaxy roles and collections..."
ansible-galaxy install -r playbooks/macos_workstation/requirements.yml

# Run the macOS playbook
echo "Running macOS setup playbook..."
ansible-playbook playbooks/macos_workstation/playbook.yml -K
