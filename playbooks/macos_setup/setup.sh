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

# Ensure Ansible is not installed via Homebrew to avoid conflicts
if command -v ansible &> /dev/null; then
    echo "Ansible found. Uninstalling Ansible..."
    brew uninstall ansible
fi

# Ensure Python and Pipx are installed via Homebrew
echo "Installing Python and Pipx via Homebrew..."
brew install python pipx

# Ensure Pipx path is added to PATH
echo "Ensuring pipx path is added to PATH..."
pipx ensurepath
export PATH="$HOME/.local/bin:$PATH"  # Add pipx default path
export PATH="$HOME/.local/pipx/venvs/ansible/bin:$PATH"  # Add Ansible virtual environment

# Debug PATH
echo "PATH after pipx ensurepath and export: $PATH"

# Install or fix Ansible installation via Pipx
echo "Installing or fixing Ansible via Pipx..."
pipx install ansible

# Verify Ansible installation
if ! command -v ansible &> /dev/null; then
    echo "Ansible not found in PATH. Attempting to link manually..."
    ln -sf ~/.local/pipx/venvs/ansible/bin/ansible ~/.local/bin/ansible
    ln -sf ~/.local/pipx/venvs/ansible/bin/ansible-playbook ~/.local/bin/ansible-playbook
    ln -sf ~/.local/pipx/venvs/ansible/bin/ansible-galaxy ~/.local/bin/ansible-galaxy
fi

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
