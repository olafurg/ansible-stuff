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

- **Root SSH access to the target *before* the first run.** This playbook connects as `ansible_user: root` over SSH — it does not use `become`/sudo escalation from a lower-privilege user, and it does not fall back to a password if key auth fails.
  - **Fresh Debian install (most common case):** a stock Debian install typically has `PermitRootLogin prohibit-password` (or password auth disabled some other way) and an **empty** `/root/.ssh/authorized_keys`. Key auth *and* password auth will both fail here — Ansible will error with `Permission denied (publickey,password)`. You must seed at least one key into `/root/.ssh/authorized_keys` out-of-band first (console/KVM, cloud-init, a provisioning script, or manually via local sudo: `sudo mkdir -p /root/.ssh && sudo tee -a /root/.ssh/authorized_keys` with the key from `base_debian_server_authorized_keys` below) before this playbook can reach the box at all.
  - **Existing/previously-baselined server:** if root password login is still enabled and a password is known, `-K`'s sudo-password prompt is irrelevant here (there's no `become` step) — you'd need `--ask-pass` instead, and even then only works until a previous run of this same playbook has already disabled it.
- `inventories/group_vars/servers.yml` with `base_debian_server_authorized_keys` populated with the keys you want authorized — this is what gets deployed *once you're already in*, not what gets you in the first time.
- `inventories/inventory.yml` has the correct `ansible_host` IP for each server — a stale/wrong IP will fail the same way as a missing key (connection/auth failure), so verify reachability (`ping`/`ssh -v`) if you get a surprise `UNREACHABLE`.
- Collections installed: `ansible-galaxy collection install -r requirements.yml`
- Hosts that should not use UFW (for example Proxmox hypervisors) should use a dedicated playbook or set `base_debian_server_manage_firewall: false`

## What gets applied

See [roles/base_debian_server/README.md](../../roles/base_debian_server/README.md) for full details.
