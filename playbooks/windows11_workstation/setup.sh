#!/bin/bash
set -euo pipefail

# Windows 11 workstation setup (Phase 2). Run from inside WSL.
#
# cd to the repo root (two levels up) so ansible.cfg and its roles_path are
# honoured regardless of where this script is invoked from.
cd "$(dirname "$0")/../.."

# Install prerequisites
sudo apt update
sudo apt -y install git ansible

# Run the Windows 11 workstation playbook
ansible-playbook playbooks/windows11_workstation/playbook.yml
