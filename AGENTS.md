# AGENTS.md

## Key rules

- **NEVER run playbooks** (`make macos`, `make debian`) — they modify the system and require interactive sudo
- **After any edit**: run `make lint`, then `make check`
- Linting config lives in `.yamllint` and `.ansible-lint` — read those for formatting rules, don't guess

## Project conventions

- FQCNs required: `ansible.builtin.*`, `community.general.*`
- Task names: capital letter, imperative mood (e.g., "Install Vim")
- Role names: `lowercase_with_underscores` (e.g., `visual_studio_code`)
- Tags: use role name as tag (e.g., `tags: [vim]`)
- OS-specific task files: `debian_ubuntu.yml`, `macos.yml`, `arch_linux.yml`
- Roles store config files in `files/`, symlinked to home via `{{ role_path }}/files/`
- Use `{{ ansible_facts.env.HOME }}` for home directory paths
