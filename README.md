# Ansible stuff

My Ansible config. So far only for local machine and server.

Actively moving stuff over from the dotfiles repo.

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

To run a playbook, for example:

    ansible-playbook playbooks/wsl-ubuntu-setup.yml -K

The ```-K``` is to prompt for sudo password.
