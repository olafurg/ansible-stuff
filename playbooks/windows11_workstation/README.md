# Windows 11 Workstation Setup

This playbook automates the setup of a Windows 11 workstation with all necessary applications and configurations. It is designed to be run from a WSL (Windows Subsystem for Linux) control node.

## Execution model

Ansible's control node cannot run on native Windows, so setup happens in two phases:

1. **PowerShell bootstrap (pre-WSL):** Anything that must exist before Ansible can run — installing WSL itself (`wsl --install`) and any bootstrap apps — is done from an elevated PowerShell prompt. Ansible cannot own this step because it cannot run before WSL exists.
2. **Ansible-in-WSL (this playbook):** Once WSL is present, the playbook runs *inside* WSL. Roles that configure Windows itself (e.g. `windows_terminal`) reach the Windows filesystem via `/mnt/c` — no WinRM or Windows Ansible collections required.

## Prerequisites

- Windows 11 (Windows Terminal ships with it — no install needed)
- Administrator privileges on the Windows host

Everything else is installed by the two steps below.

## Setup

### Phase 1 — Windows (elevated PowerShell)

Install WSL. This is the only step that runs outside WSL.

```powershell
playbooks\windows11_workstation\bootstrap.ps1
```

(Equivalent to running `wsl --install`.) Reboot if prompted, then launch **Ubuntu**
from the Start menu and create your UNIX user.

### Phase 2 — inside WSL (Ubuntu)

Clone the repo into your **WSL home** (`~`), not `/mnt/c` — Ansible ignores
`ansible.cfg` on the world-writable `/mnt/c` mount, which breaks role resolution.

```bash
sudo apt update && sudo apt -y install git
git clone https://github.com/olafurg/ansible-stuff.git ~/ansible-stuff
~/ansible-stuff/playbooks/windows11_workstation/setup.sh
```

`setup.sh` installs Ansible, cd's to the repo root, and runs the playbook.
Comment out any unwanted roles in `playbook.yml` first.

## What Gets Configured

Currently implemented:
- **Windows Terminal** — Catppuccin Frappe/Latte color schemes that auto-switch with the system light/dark theme

> **How the Windows Terminal role works:** it *merges* managed keys into the live `settings.json` at
> `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\` (reached from WSL via `/mnt/c`),
> rather than overwriting the file. A whole-file overwrite would wipe Windows Terminal's auto-generated
> profiles (WSL distros, PowerShell, Git Bash) — and because WT records generated profiles in `state.json`,
> it would then treat them as user-deleted and refuse to regenerate them. The merge preserves that list and
> only sets the theme, Catppuccin color schemes, and default font. The previous file is backed up to
> `settings.json.ansible.bak`.
>
> Debian is added as an explicit **static** profile (`commandline: wsl.exe -d Debian`, no `source`) and set as
> the default. A static profile is used deliberately: WT's WSL generator assigns non-deterministic GUIDs, and a
> stub referencing the wrong GUID would be hidden. The trade-off is that if WT's generator later creates its own
> Debian profile, you may see two "Debian" entries — delete the generated one (or `state.json`) if so.

Planned (see the commented role list in `playbook.yml`): base Windows tweaks,
winget apps (Brave, Discord, PowerToys, Signal, Spotify), 1Password + SSH agent,
Git, and Visual Studio Code. These roles still need to be built.

## Troubleshooting

- **"role not found":** you're running from `/mnt/c`. Clone into your WSL home (`~`) instead — see Phase 2.
- **`wsl --install` did nothing:** ensure you ran PowerShell as Administrator, then reboot.
- Check that Windows 11 is up to date and you have a stable internet connection.
- Re-run with `-vvv` for verbose Ansible output.
