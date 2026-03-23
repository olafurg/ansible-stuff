# Vim Role

Installs Vim/MacVim and configures it with custom `.vimrc` and UltiSnips snippets.

## Description

This role installs Vim (or MacVim on macOS) and creates symlinks to custom configuration files and UltiSnips snippets stored in the role's `files/` directory.

## Supported Platforms

- macOS (Darwin) - installs MacVim
- Debian/Ubuntu - installs Vim
- Arch Linux - installs Vim

## Variables

None. This role uses no configurable variables.

## Files

- `files/.vimrc` - Vim configuration file (symlinked to `~/.vimrc`)
- `files/.vim/UltiSnips/` - UltiSnips snippet directory (symlinked to `~/.vim/UltiSnips`)

## Usage

Include this role in your playbook:

```yaml
roles:
  - vim
```

Or run with tags:

```bash
ansible-playbook playbook.yml --tags vim
```

## Dependencies

None.
