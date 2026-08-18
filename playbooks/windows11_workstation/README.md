# Windows 11 Workstation Setup

This playbook automates the setup of a Windows 11 workstation with all necessary applications and configurations. It is designed to be run from a WSL (Windows Subsystem for Linux) control node.

## Execution model

Ansible's control node cannot run on native Windows, so setup happens in two phases:

1. **PowerShell bootstrap (pre-WSL):** Anything that must exist before Ansible can run — installing WSL itself and the Debian and Arch Linux distributions — is done from an elevated PowerShell prompt. Ansible cannot own this step because it cannot run before WSL exists.
2. **Ansible-in-WSL (this playbook):** Once WSL is present, the playbook runs *inside* WSL. Roles that configure Windows itself (e.g. `windows_terminal`) reach the Windows filesystem via `/mnt/c` — no WinRM or Windows Ansible collections required.

## Prerequisites

- Windows 11 (Windows Terminal ships with it — no install needed)
- Administrator privileges on the Windows host

Everything else is installed by the two steps below.

## Setup

### Phase 1 — Windows (elevated PowerShell)

Install WSL plus the Debian and Arch Linux distributions. This is the only step
that runs outside WSL.

```powershell
playbooks\windows11_workstation\bootstrap.ps1
```

Both are official Microsoft Store distros, so each gets its own Start menu
entry and Windows Terminal profile icon automatically — no extra config
needed. Reboot if prompted, then launch **Debian** and/or **archlinux** from
the Start menu and create your UNIX user for each.

### Phase 2 — inside WSL

Clone the repo into your **WSL home** (`~`), not `/mnt/c` — Ansible ignores
`ansible.cfg` on the world-writable `/mnt/c` mount, which breaks role resolution.
Do this inside each distro you installed:

```bash
# Debian
sudo apt update && sudo apt -y install git
git clone https://github.com/olafurg/ansible-stuff.git ~/ansible-stuff
~/ansible-stuff/playbooks/debian_ubuntu_wsl/setup.sh   # Debian/WSL-specific roles (npm, etc.)
```

```bash
# archlinux
sudo pacman -Syu --needed git
git clone https://github.com/olafurg/ansible-stuff.git ~/ansible-stuff
~/ansible-stuff/playbooks/arch_linux_wsl/setup.sh      # Arch/WSL-specific roles
```

Then, from **either** distro (once — not both), configure the Windows side:

```bash
~/ansible-stuff/playbooks/windows11_workstation/setup.sh
```

This playbook writes only to the Windows filesystem via `/mnt/c`, so unlike the
per-distro scripts above it is distro-agnostic: it detects apt/pacman/dnf for
its prerequisites and behaves identically from Debian or Arch. Running it from
both distros is harmless but pointless — it would just merge the same keys into
the same Windows-side settings file twice.

Each `setup.sh` installs Ansible, cd's to the repo root, and runs its playbook.
Comment out any unwanted roles in the relevant `playbook.yml` first.

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
> Debian is added as an explicit **static** profile (`commandline: wsl.exe -d Debian --cd ~`, no `source`), while
> PowerShell 7 stays the default profile. The static entry deliberately reuses the GUID WT's own WSL generator
> would assign to a distro named `Debian` — that GUID is deterministic, `UUIDv5(ns={2bde4a90-d05f-401c-9492-e40884ead1d8},
> utf16le("Debian"))` = `{58ad8b0c-3ef8-5f4d-bc6f-13e4c00f2530}` — so it is the same on every machine. Reusing it
> means WT merges the generated profile (icon and all) into ours instead of showing two "Debian" entries, and it
> keeps the GUID present in `settings.json`, which is what stops WT from tombstoning the generated profile.
>
> Distros installed by modern WSL (e.g. `archlinux`) instead get their own profile *fragment* at
> `%LOCALAPPDATA%\Microsoft\Windows Terminal\Fragments\Microsoft.WSL\{guid}.json`, which supplies their icon and
> hides the legacy generated profile. The Microsoft Store Debian package does not ship one, which is why Debian
> needs the entry above.

Planned (see the commented role list in `playbook.yml`): base Windows tweaks,
winget apps (Brave, Discord, PowerToys, Signal, Spotify), 1Password + SSH agent,
Git, and Visual Studio Code. These roles still need to be built.

## Troubleshooting

- **"role not found":** you're running from `/mnt/c`. Clone into your WSL home (`~`) instead — see Phase 2.
- **`bootstrap.ps1` did nothing:** ensure you ran PowerShell as Administrator, then reboot.
- **A distro is installed (`wsl -l -v` lists it) but missing from the Windows Terminal dropdown:** its generated
  profile has been *tombstoned*. WT records every profile GUID it generates in
  `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\state.json` under
  `generatedProfiles`; if a recorded GUID is absent from `settings.json`, WT treats it as user-deleted and never
  shows it again. Re-running this playbook fixes it for Debian (the managed profile puts the GUID back). For any
  other distro: close Windows Terminal, delete that distro's GUID from `generatedProfiles` in `state.json`, and
  relaunch.
- **Generic penguin instead of the distro's logo:** expected for Debian. Windows Terminal takes WSL profile icons
  from a *fragment* the distro registers at install time. Modern tar-based installs (e.g. `archlinux`) write one;
  the Microsoft Store Debian package does not (its `AppxManifest.xml` declares only an `appExecutionAlias`), so WT
  has no icon to use. Set `icon` explicitly on the profile if you want the Debian logo.
- Check that Windows 11 is up to date and you have a stable internet connection.
- Re-run with `-vvv` for verbose Ansible output.
