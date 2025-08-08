#!/bin/sh

# trigger.sh - Run this inside Podman container
# Triggers the listener on the host machine with a custom message
#
# Usage:
#   ./trigger.sh                           # Uses default port 8080 and message
#   ./trigger.sh 9000                      # Custom port, default message  
#   ./trigger.sh 8080 "Hello world"        # Default port, custom message
#   ./trigger.sh 9000 "Custom message"     # Custom port and message

HOST="host.containers.internal"
MESSAGE=${1:-"hello from container"}
PORT=${2:-8080}

echo "Triggering listener at $HOST:$PORT with message: '$MESSAGE'"

if command -v nc >/dev/null 2>&1; then
    # Send message and close connection immediately
    # Try different approaches depending on netcat version
    # note WINID is set as an environment variable from the terminal window where claude-container is run
    if nc -h 2>&1 | grep -q '\-w'; then
        printf "%s\n%s\n" "$WINID" "$MESSAGE" | nc -w 1 $HOST $PORT
    else
        # Use timeout command as fallback
        printf "%s\n%s\n" "$WINID" "$MESSAGE" | timeout 2 nc $HOST $PORT
    fi

    if [ $? -eq 0 ]; then
        echo "✅ Successfully triggered listener!"
    else
        echo "❌ Failed to connect to listener"
        exit 1
    fi
else
    echo "❌ netcat (nc) not found. Install it first:"
    if [ -f /etc/os-release ]; then
    . /etc/os-release
    fi
    distro=${ID:-}
    case "$distro" in
        ubuntu|debian) echo "To install netcat, run: sudo apt update && sudo apt install netcat" ;;
        fedora) echo "To install netcat, run: sudo dnf install nmap-ncat" ;;
        centos|rhel) echo "To install netcat, run: sudo yum install nmap-ncat" ;;
        arch) echo "To install netcat, run: sudo pacman -S gnu-netcat" ;;
        opensuse*|suse) echo "To install netcat, run: sudo zypper install netcat" ;;
        *) echo "Unknown or unsupported distribution: $distro" ;;
    esac
    exit 1
fi
