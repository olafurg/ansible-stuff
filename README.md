# Ansible stuff

My Ansible config. So far only for local machine and server.

Actively moving stuff over from the dotfiles repo.

TODO:
- [ ] check oh-my-zsh idempotancy
- [ ] terminator
- [ ] mousewheel config

## Linux - Debian or Ubuntu

To set up a new machine, you need to install ansible first.
    
    sudo apt update && sudo apt-get upgrade
    sudo apt -y install ansible git curl

Then clone the repository and run a playbook.

To run a playbook, for example:

    ansible-playbook playbooks/wsl-ubuntu-setup.yml -K

The ```-K``` is to prompt for sudo password.

## macOS
See the ```macos-cm``` directory. Run a playbook on the Mac itself with:

    ansible-playbook main.yml -i inventory -K

## When conditionals

  ```
  when: ansible_facts['distribution'] in ['Debian', 'Ubuntu']
  when: ansible_facts['os_family'] in ['Darwin', 'Linux', 'Windows']
  ```

  https://techviewleo.com/list-of-ansible-os-family-distributions-facts/
