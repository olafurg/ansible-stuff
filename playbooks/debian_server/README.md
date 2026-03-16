# debian_server playbook

Applies the `base_debian_server` baseline to all servers in the `servers` inventory group.

## Intent

This is the **baseline** — run it on any new Debian 13 server before any service-specific configuration. It leaves the server in a known-good, hardened state.

For service-specific setup (Mattermost, Ollama, Pi-hole etc.), use the dedicated playbooks in their respective directories. Those playbooks include this baseline role as their first step.

## Usage

```bash
# Apply baseline to all servers
ansible-playbook playbooks/debian_server/playbook.yml -i inventories/inventory.yml

# Apply to a single server
ansible-playbook playbooks/debian_server/playbook.yml -i inventories/inventory.yml --limit ollama
```

## Prerequisites

- SSH access to target servers (password or key)
- `inventories/group_vars/servers.yml` with `base_debian_server_authorized_keys` populated
- Collections installed: `ansible-galaxy collection install -r requirements.yml`

## What gets applied

See [roles/base_debian_server/README.md](../../roles/base_debian_server/README.md) for full details.
