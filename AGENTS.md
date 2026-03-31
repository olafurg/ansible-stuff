# AGENTS.md

## Key rules

- **NEVER run playbooks** (`make macos`, `make debian`) — they modify the system and require interactive sudo
- **After any edit**: run `make lint`, then `make check`
- Linting config lives in `.yamllint` and `.ansible-lint` — read those for formatting rules, don't guess

## Repo structure

- `playbooks/{os}_workstation/playbook.yml` — per-OS entry points
- `roles/{name}/tasks/main.yml` — main task file, includes OS-specific files
- `roles/{name}/files/` — dotfiles/configs that get symlinked to `$HOME`
- Config: `.yamllint`, `.ansible-lint`, `Makefile`, `requirements.yml`

## Project conventions

- FQCNs required: `ansible.builtin.*`, `community.general.*`
- Task names: capital letter, imperative mood (e.g., "Install Vim")
- Role names: `lowercase_with_underscores` (e.g., `visual_studio_code`)
- Tags: use role name as tag (e.g., `tags: [vim]`)
- OS-specific task files: `debian_ubuntu.yml`, `macos.yml`, `arch_linux.yml`
- Roles store config files in `files/`, symlinked to home via `{{ role_path }}/files/`
- Use `{{ ansible_facts.env.HOME }}` for home directory paths

## Common patterns

Symlink a config file from a role:

```yaml
- name: Create symlink for config file
  ansible.builtin.file:
    src: "{{ role_path }}/files/.config"
    dest: "{{ ansible_facts.env.HOME }}/.config"
    state: link
    force: true
```

Install packages with OS detection:

```yaml
- name: Install package on Debian/Ubuntu
  ansible.builtin.apt:
    name: "{{ item }}"
    state: present
  loop: "{{ debian_packages }}"
  when: ansible_facts['os_family'] in ['Debian', 'Ubuntu']
  become: true
```
