# First run (on a new Mac)

From here: https://austincloud.guru/2020/05/07/automating-macos-configuration/

    git clone https://${YOUR_GIT_REPO}
    cd ${YOUR_GIT_REPO}

then

    sudo easy_install pip
    sudo pip install ansible
    ansible-galaxy collection install geerlingguy.mac --ignore-certs
    # osascript needed to setup sandboxing for the terminal
    osascript -e 'tell application "Finder"' -e 'set _b to bounds of window of desktop' -e 'end tell'
    ansible-playbook main.yml -i inventory -K

Following any changes, it's sufficient to just run the playbook:

    ansible-playbook main.yml -i inventory -K