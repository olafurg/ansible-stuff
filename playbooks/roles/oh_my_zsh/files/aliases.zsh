# Aliases for zsh

alias lla='ls -lah'
alias rm='rm -i'
alias mv='mv -i'
alias update='sudo -- sh -c "apt update && apt -y upgrade && apt -y --purge autoremove && apt -y clean"'
alias digs='dig +short'