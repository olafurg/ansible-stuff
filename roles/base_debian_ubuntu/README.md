# base_debian_ubuntu

Baseline role for Debian/Ubuntu **workstations** and WSL environments. Installs common utilities and development tools.

## What it does

- **Packages**: updates apt and installs common utilities (`ansible`, `curl`, `git`, `htop`, `vim`, `tree`, `dnsutils`) and networking/diagnostic tools (`nmap`, `masscan`, `traceroute`, `whois`)

## Usage

Used as the first role in workstation and WSL playbooks:

```bash
ansible-playbook playbooks/debian_ubuntu_workstation/playbook.yml -i inventories/inventory.yml
ansible-playbook playbooks/debian_ubuntu_wsl/playbook.yml -i inventories/inventory.yml
```

## Related

- [`base_debian_server`](../base_debian_server/) — server baseline with hardening (UFW, fail2ban, SSH key-only, auto-updates). Use that for servers, this for desktops/WSL.
