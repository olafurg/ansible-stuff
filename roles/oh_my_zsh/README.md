# Oh My Zsh Role

Installs Zsh, Oh My Zsh, and configures custom aliases.

## Description

This role installs Zsh and Git, sets Zsh as the default shell, installs Oh My Zsh, and creates symlinks to OS-specific alias files.

## Supported Platforms

- macOS (Darwin)
- Debian/Ubuntu

## Variables

None. This role uses no configurable variables.

## Files

- `files/custom/aliases_macos.zsh` - macOS-specific aliases (symlinked to `~/.oh-my-zsh/custom/aliases.zsh`)
- `files/custom/aliases_debian_ubuntu.zsh` - Debian/Ubuntu-specific aliases

## Usage

Include this role in your playbook:

```yaml
roles:
  - oh_my_zsh
```

## Notes

- After initial installation, you may need to restart your terminal session for changes to take effect
- The role will change your default shell to Zsh if it's not already set
- Custom aliases are automatically sourced in `.zshrc`

## Dependencies

None.
