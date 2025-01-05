# Ansible stuff

My Ansible config. Installations and config/dotfiles.

TODO:
- [ ] macos from other repo
- [ ] manjaro/arch
- [ ] mousewheel config from setup-linux

## Linux - Debian or Ubuntu

To prep:
    
    sudo apt update && sudo apt upgrade
    sudo apt -y install ansible git curl

Then clone the repository and run a playbook. For example:

    ansible-playbook playbooks/debian-ubuntu.yml -K

The ```-K``` is to prompt for sudo password.

## macOS
_To be cleaned up_
See the ```macos-cm``` directory. Run a playbook on the Mac itself with:

    ansible-playbook main.yml -i inventory -K

## When conditionals

  ```
  when: ansible_facts['distribution'] in ['Debian', 'Ubuntu']
  when: ansible_facts['os_family'] in ['Darwin', 'Linux', 'Windows']
  ```

  https://techviewleo.com/list-of-ansible-os-family-distributions-facts/
