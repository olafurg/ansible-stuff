#Requires -RunAsAdministrator

# Windows 11 workstation bootstrap (Phase 1).
#
# Ansible cannot run on native Windows, so this is the ONLY step that runs
# outside WSL. It installs the WSL platform plus the Debian and Arch Linux
# distributions (both official Microsoft Store distros, so each gets its own
# Start menu entry and Windows Terminal icon automatically); everything else
# (including Windows Terminal theming) is handled by the Ansible playbooks
# from inside WSL in Phase 2.
#
# Windows Terminal itself ships with Windows 11, so it is not installed here.
#
# Run from an elevated PowerShell prompt:
#     ./bootstrap.ps1

Write-Host "Installing the WSL platform..." -ForegroundColor Cyan
wsl --install --no-distribution

Write-Host "Installing Debian..." -ForegroundColor Cyan
wsl --install -d Debian

Write-Host "Installing Arch Linux..." -ForegroundColor Cyan
wsl --install -d archlinux

Write-Host ""
Write-Host "Bootstrap complete." -ForegroundColor Green
Write-Host "1. Reboot if prompted."
Write-Host "2. Launch 'Debian' and/or 'archlinux' from the Start menu and create your UNIX user(s)."
Write-Host "3. Continue with Phase 2 (see README.md)."
