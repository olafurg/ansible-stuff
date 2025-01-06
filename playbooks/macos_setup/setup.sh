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

# Reload shell to apply PATH changes (if necessary)
echo "Reloading shell to apply PATH changes..."
source ~/.zshrc || source ~/.bashrc || echo "Please restart your terminal or reload your shell manually."

# Install Ansible via Pipx
echo "Installing Ansible via Pipx..."
pipx install ansible

# Verify Ansible installation
if ! command -v ansible &> /dev/null; then
    echo "Ansible installation failed. Check your Pipx setup."
    exit 1
fi

# Install required Ansible Galaxy roles and collections
echo "Installing Ansible Galaxy roles and collections..."
ansible-galaxy install -r playbooks/macos_setup/requirements.yml

# Run the macOS playbook
echo "Running macOS setup playbook..."
ansible-playbook playbooks/macos_setup/playbook.yml -K
