## Windows 11 machine
Setting up a fresh machine is a bit of a thing.

1. Install and log in to 1Password
1. Log in to GitHub
1. Install WSL
1. In WSL:
    1. Install prereqs: ```sudo apt install -y git gh```
    1. Authenticate to GitHub: ```gh auth login```
    1. Clone this repo: ```gh repo clone olafurg/ansible-stuff```
    1. Run the wsl-ubuntu setup playbook
1. In 1Password > Settings > Developer
    1. Enable "Use the SSH agent"
    1. Enable "Integrate with 1Password CLI"
1. Configure WSL to work with 1Password, for SSH keys and such (guide here: https://www.notion.so/olafurg/1Password-30b9cb836f05445f97618a6471f79b4f):
    1. In Windows:
        1. Set up the 1Password SSH agent config file (toml) in Windows
        1. Create directory ```%localappdata%/npiperelay/```
        1. Adjust path system environment variable to include that path
    1. Download npiperelay, extract the executable and put in that directory
    1. In WSL:
        1. Run: ```./wsl_prep.sh```
    1. https://developer.1password.com/docs/ssh/agent/config/
1. Reboot the computer
