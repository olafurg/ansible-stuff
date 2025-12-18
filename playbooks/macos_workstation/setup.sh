#!/bin/zsh
set -e  # Exit on error
set -u  # Exit on undefined variable

# Ensure Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if ! command -v brew &> /dev/null; then
        echo "ERROR: Homebrew installation failed. Please install it manually and re-run this script."
        exit 1
    fi
fi


# Ensure Python, Pipx, and mas are installed via Homebrew
echo "Installing Python and Pipx via Homebrew..."
brew install python pipx

# Ensure Pipx path is added to PATH
pipx ensurepath
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/pipx/venvs/ansible/bin:$PATH"

# Install Ansible via Pipx (skip if already installed)
if ! command -v ansible &> /dev/null; then
    echo "Installing Ansible via Pipx..."
    pipx install --include-deps ansible
else
    echo "Ansible is already installed. Skipping installation."
fi

# Verify Ansible installation
if ! command -v ansible &> /dev/null; then
    echo "ERROR: Ansible installation failed. Try running 'pipx ensurepath' and restart your terminal."
    exit 1
fi

# Install required Ansible Galaxy roles and collections
echo "Installing Ansible Galaxy roles and collections..."
ansible-galaxy install -r requirements.yml

# Run the macOS playbook
echo "Running macOS setup playbook..."
ansible-playbook playbooks/macos_workstation/playbook.yml -K
