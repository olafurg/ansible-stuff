# base_debian_server

Baseline role for all Debian 13 (Trixie) homelab servers. Provides a known-good, hardened starting point before any service-specific configuration.

## What it does

- **Packages**: installs essential server utilities (ansible, curl, git, htop, tmux, vim, etc.)
- **Timezone**: sets `Atlantic/Reykjavik`
- **Auto-updates**: configures `unattended-upgrades` for security patches (no auto-reboot)
- **SSH keys**: deploys authorized keys before hardening (prevents lockout)
- **SSH hardening**: disables password auth, prohibits root password login, disables X11 forwarding
- **Firewall**: enables UFW, denies all incoming, allows SSH (port 22)
- **fail2ban**: enabled and started

## Variables

| Variable | Default | Description |
|---|---|---|
| `base_debian_server_authorized_keys` | `[]` | List of SSH public key strings to authorize for root. Override in `group_vars/servers.yml` or `host_vars/<host>.yml` |

## Usage

This role is not meant to be run standalone. It is the foundation for server-specific playbooks:

```yaml
- name: Set up my server
  hosts: my_server
  become: true
  roles:
    - base_debian_server
    - my_service_role
```

## Notes

- **Break-glass**: if SSH access is lost, use the Proxmox console — it does not require SSH.
- **UFW**: only port 22 is open after this role runs. Service-specific playbooks add their own ports.
- **Reboot**: `unattended-upgrades` will not auto-reboot. Kernel updates require a manual reboot.
