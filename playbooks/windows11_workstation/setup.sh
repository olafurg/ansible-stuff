#!/bin/bash
set -euo pipefail

# Windows 11 workstation setup (Phase 2). Run from inside WSL.
#
# Unlike the other setup.sh scripts, this one is distro-agnostic on purpose:
# the playbook configures *Windows* through /mnt/c and touches nothing in the
# Linux filesystem, so whichever WSL distro you happen to be in (Debian, Arch,
# ...) is incidental. Only the prerequisite install differs, so that is the
# only branch below.
#
# cd to the repo root (two levels up) so ansible.cfg and its roles_path are
# honoured regardless of where this script is invoked from.
cd "$(dirname "$0")/../.."

if ! grep -qi microsoft /proc/version 2>/dev/null; then
    echo "ERROR: this must run inside WSL — the playbook reaches Windows via /mnt/c." >&2
    exit 1
fi

# Install prerequisites with whichever package manager this distro provides.
# Nothing is installed (and no package DB is refreshed) when both are present,
# so re-running from an already-configured distro is cheap.
missing=()
command -v git &> /dev/null || missing+=(git)
command -v ansible-playbook &> /dev/null || missing+=(ansible)

if [ ${#missing[@]} -gt 0 ]; then
    echo "Installing prerequisites: ${missing[*]}"
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get -y install "${missing[@]}"
    elif command -v pacman &> /dev/null; then
        # -Syu rather than -Sy: a partial upgrade on Arch is unsupported.
        sudo pacman -Syu --needed "${missing[@]}"
    elif command -v dnf &> /dev/null; then
        sudo dnf -y install "${missing[@]}"
    else
        echo "ERROR: no supported package manager (apt/pacman/dnf) found." >&2
        echo "Install ${missing[*]} manually, then re-run this script." >&2
        exit 1
    fi
fi

# The locale is forced because the Arch WSL image ships without a generated
# one, which makes Ansible fall back to ASCII and mangle non-ASCII output.
LANG=C.UTF-8 LC_ALL=C.UTF-8 ansible-playbook playbooks/windows11_workstation/playbook.yml
