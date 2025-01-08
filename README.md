# Ansible stuff

My Ansible config. Installations and config/dotfiles.

TODO:
- [ ] macos powerline tmux ruby
- [ ] playbook setup scripts
- [ ] manjaro/arch
- [ ] mousewheel config from setup-linux

## macOS
Run the playbook's `setup.sh` script, from the repo root directory.

    playbooks/macos_setup/setup.sh

The script ensures prerequisites are installed and runs the setup playbook. Those being for example Homebrew, Python, Pipx and Ansible.

After the initial setup you can keep running the setup script or run only the playbook if you're sure you have the environment set up. See the script for how the playbook is run.

## Linux Debian/Ubuntu
Run the playbook's `setup.sh` script, from the repo root directory. For example:

    playbooks/debian_ubuntu_desktop/setup.sh

The script ensures prerequisites are installed and runs the setup playbook. Those being for Ansible.

After the initial setup you can keep running the setup script or run only the playbook if you're sure you have the environment set up. See the script for how the playbook is run.

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
