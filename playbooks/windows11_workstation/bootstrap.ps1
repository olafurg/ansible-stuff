#Requires -RunAsAdministrator

# Windows 11 workstation bootstrap (Phase 1).
#
# Ansible cannot run on native Windows, so this is the ONLY step that runs
# outside WSL. It installs WSL + the default Ubuntu distribution; everything
# else (including Windows Terminal theming) is handled by the Ansible playbook
# from inside WSL in Phase 2.
#
# Windows Terminal itself ships with Windows 11, so it is not installed here.
#
# Run from an elevated PowerShell prompt:
#     ./bootstrap.ps1

Write-Host "Installing WSL and the default Ubuntu distribution..." -ForegroundColor Cyan
wsl --install

Write-Host ""
Write-Host "Bootstrap complete." -ForegroundColor Green
Write-Host "1. Reboot if prompted."
Write-Host "2. Launch 'Ubuntu' from the Start menu and create your UNIX user."
Write-Host "3. Continue with Phase 2 (see README.md)."
