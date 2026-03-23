# Ansible Stuff

[![Ansible Lint](https://github.com/olafurg/ansible-stuff/actions/workflows/ci.yml/badge.svg)](https://github.com/olafurg/ansible-stuff/actions/workflows/ci.yml)

My personal Ansible configuration, installations, and dotfiles.

## Usage

Each OS/platform has its own playbook directory with a `setup.sh` script to handle prerequisites and execution.

### macOS
Run from the root directory:
```bash
./playbooks/macos_workstation/setup.sh
```

### Arch Linux workstation
Run from the root directory:
```bash
./playbooks/arch_linux_workstation/setup.sh
```

### Debian/Ubuntu workstation
Run from the root directory:
```bash
./playbooks/debian_ubuntu_workstation/setup.sh
```

### Debian server baseline
Apply the generic Debian server baseline with:
```bash
ansible-playbook playbooks/debian_server/playbook.yml -i inventories/inventory.yml
```

### Proxmox host
Apply the Proxmox hypervisor baseline with:
```bash
ansible-playbook playbooks/proxmox_host/playbook.yml -i inventories/inventory.yml
```

### Other Platforms
- **Manjaro:** See `playbooks/manjaro_workstation/README.md`
- **WSL:** See relevant `*_wsl` directories in `playbooks/`

## Development

### Linting & Formatting
This repo uses `ansible-lint` and `pre-commit` to maintain quality.

1.  **Install Pre-commit Hooks** (runs automatically on git commit):
    ```bash
    pre-commit install
    ```

2.  **Run Linting Manually:**
    ```bash
    ansible-lint
    ```

3.  **Run Formatting Manually:**
    ```bash
    pre-commit run --all-files
    ```

### Reference
- **OS Families:** [Ansible OS Family Facts](https://techviewleo.com/list-of-ansible-os-family-distributions-facts/)
