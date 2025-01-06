# Ansible stuff

My Ansible config. Installations and config/dotfiles.

TODO:
- [ ] macos powerline tmux ruby ghostty
- [ ] playbook setup scripts
- [ ] manjaro/arch
- [ ] mousewheel config from setup-linux

## macOS
Run the `setup.sh` script from the repo root directory.

    playbooks/macos_setup/setup.sh

The script ensures prerequisites are installed and runs the setup playbook. You can also run the playbook manually if you're sure you have prerequisites. See the script for how that's run.

## Linux Debian/Ubuntu
To prep:

    sudo apt update && sudo apt upgrade
    sudo apt -y install ansible git curl

Then clone the repository and run a playbook. For example:

    ansible-playbook playbooks/debian_ubuntu_desktop.yml -K

The `-K` is to prompt for sudo password.

## Linux Manjaro
See README.md in that playbook dir. Needs integrating with roles/configs.

## Windows
See README.md in that playbook dir. Very little.

## When conditionals
To use in OS conditionals.

Example:
  ```
  when: ansible_facts['os_family'] in ['Debian', 'Ubuntu', 'Darwin', 'Windows']
  ```

  https://techviewleo.com/list-of-ansible-os-family-distributions-facts/
