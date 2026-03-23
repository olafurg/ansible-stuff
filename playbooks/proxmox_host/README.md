# proxmox_host playbook

Applies a safe baseline to a Proxmox VE host while preserving Proxmox-specific expectations.

## Intent

This playbook is for the hypervisor itself, not guest VMs/LXCs.

It handles the practical differences we hit on a fresh Proxmox host:
- switches from enterprise-only repo definitions to no-subscription repos when needed
- applies the Debian baseline role
- disables UFW management by default, since Proxmox has its own firewall model

## Usage

```bash
# Apply baseline to all proxmox_hosts
ansible-playbook playbooks/proxmox_host/playbook.yml -i inventories/inventory.yml

# Apply to a single host
ansible-playbook playbooks/proxmox_host/playbook.yml -i inventories/inventory.yml --limit pve
```

## Inventory

Put Proxmox hosts in a dedicated `proxmox_hosts` group.

Example:

```yaml
all:
  children:
    proxmox_hosts:
      hosts:
        pve:
          ansible_host: 192.168.1.100
          ansible_user: root
```

## Notes

- This playbook currently assumes Proxmox VE 9 / Debian 13 (`trixie`).
- If you use an enterprise subscription, do **not** use the no-subscription repo switch as-is.
- Guest VMs/LXCs should continue using `playbooks/debian_server/playbook.yml` or service-specific playbooks.
