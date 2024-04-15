# Ansible stuff

My Ansible config. So far only for local machine and server.

Actively moving stuff over from the dotfiles repo.

## Linux
Moved:
* package installs
* oh-my-zsh install (role)
* git and config (role)
* vim (role)
* tmux (role)
* terraform (role)

Next:
* ruby configs (.gemrc, .rspec, etc.)
* terminator
* mousewheel config

To set up a new machine, you need to install ansible first.
    
    sudo apt-get update && sudo apt-get upgrade
    sudo apt-get -y install ansible git

Then clone the repository and run a playbook.

To run a playbook, for example:

    ansible-playbook playbooks/wsl-ubuntu-setup.yml -K

The ```-K``` is to prompt for sudo password.

## MacOS
See the ```macos-cm``` directory. Run a playbook on the Mac itself with:

    ansible-playbook main.yml -i inventory -K
