# base_debian_server

Baseline role for all Debian 13 (Trixie) homelab servers. Provides a known-good, hardened starting point before any service-specific configuration.

## What it does

- **Packages**: installs essential server utilities (ansible, curl, git, htop, tmux, vim, nmap, traceroute, whois, etc.)
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
| `base_debian_server_manage_firewall` | `true` | Whether the role should enable/manage UFW |
| `base_debian_server_firewall_allowed_tcp_ports` | `[22]` | TCP ports to allow through UFW when firewall management is enabled |

## Usage

This role can be used in two ways:

**1. Standalone baseline** — via the `debian_server` playbook, to bring any server to a known-good state:

```bash
ansible-playbook playbooks/debian_server/playbook.yml -i inventories/inventory.yml
```

**2. As the first role in a service-specific playbook** — apply the baseline then layer on service configuration:

```yaml
- name: Set up Mattermost server
  hosts: mattermost
  become: true
  roles:
    - base_debian_server  # baseline first
    - mattermost          # then service-specific
```

## Notes

- **Break-glass**: if SSH access is lost, use the Proxmox console — it does not require SSH.
- **UFW**: by default only port 22 is open after this role runs. Service-specific playbooks can add their own ports or disable firewall management entirely.
- **Proxmox hosts**: prefer a dedicated Proxmox playbook/role and disable UFW management there unless you explicitly want UFW on the hypervisor.
- **Reboot**: `unattended-upgrades` will not auto-reboot. Kernel updates require a manual reboot.

## Related

- [`base_debian_ubuntu`](../base_debian_ubuntu/) — workstation baseline for Debian/Ubuntu desktops and WSL. No hardening, includes workstation-specific tools. Use this for servers, that for desktops.
