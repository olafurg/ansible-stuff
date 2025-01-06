# Configure SSH forwarding with npiperelay and socat
export SSH_AUTH_SOCK=$HOME/.1password/agent.sock

# Check if npiperelay is already running
ALREADY_RUNNING=$(pgrep -f "npiperelay.exe -ei -s //./pipe/openssh-ssh-agent")

if [[ -z "$ALREADY_RUNNING" ]]; then
    # If socket file exists but the process isn't running, remove it
    if [[ -S $SSH_AUTH_SOCK ]]; then
        echo "Removing stale socket..."
        rm -f "$SSH_AUTH_SOCK" || { echo "Failed to remove socket"; exit 1; }
    fi

    # Check if socat and npiperelay are available
    command -v socat >/dev/null 2>&1 || { echo "socat is not installed. Exiting."; exit 1; }
    command -v npiperelay.exe >/dev/null 2>&1 || { echo "npiperelay.exe is not available. Exiting."; exit 1; }

    # Start SSH-Agent relay
    echo "Starting SSH-Agent relay..."
    (setsid socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork &) >/dev/null 2>&1
fi
