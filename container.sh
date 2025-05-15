#!/bin/bash

# container.sh - A script to manage containers
# Supports: build, start, run, exec, stop

set -e

# Set path to the devcontainer directory
DEVCONTAINER_DIR="$HOME/code/github.com/anthropics/claude-code/.devcontainer"

# Ensure local claude directories exist
function ensure_claude_dir {
    echo "Creating claude directories..."
    mkdir -p ./claude/config
    mkdir -p ./claude/commandhistory
}

# Function to run container with common options
function run_container {
    local mode=$1          # "detached" or "interactive"
    local container_name=$2 # Only used in detached mode
    local cmd=${3:-""}      # Command to run (optional, only used in interactive mode)

    # Common environment variables
    local env_vars=(
        "-e CLAUDE_CONFIG_DIR=/home/node/.claude"
        "-e NODE_OPTIONS=--max-old-space-size=4096"
        "-e POWERLEVEL9K_DISABLE_GITSTATUS=true"
    )

    # Common volume mounts
    local volumes=(
        "-v $(pwd)/claude/config:/home/node/.claude"
        "-v $(pwd)/claude/commandhistory:/commandhistory"
        "-v $(pwd):/workspace"
    )

    # Build the command based on mode
    if [ "$mode" = "detached" ]; then
        podman run -dit --name "$container_name" ${env_vars[@]} ${volumes[@]} claude-code
    else
        podman run --rm -it ${env_vars[@]} ${volumes[@]} claude-code ${cmd}
    fi
}

function usage {
    echo "Usage: $0 [build|start|run|exec|stop] [options]"
    echo ""
    echo "Commands:"
    echo "  build       Build the container image"
    echo "  start       Start a detached container"
    echo "  run         Run an interactive container that removes itself on exit"
    echo "  exec        Execute a command in a running container (default: zsh)"
    echo "  stop        Stop a running container"
    exit 1
}

# Generate container instance name based on parent and current directory
PARENT_DIR=$(basename "$(dirname "$(pwd)")" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g')
CURRENT_DIR=$(basename "$(pwd)" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g')
CONTAINER_NAME="${PARENT_DIR}-${CURRENT_DIR}"

# Get current timezone in IANA format (e.g. "America/New_York")
TIMEZONE=$(readlink /etc/localtime | sed 's/.*zoneinfo\///')

# Check if at least one argument is provided
if [ $# -lt 1 ]; then
    usage
fi

command=$1
shift

case $command in
    build)
        echo "Building container image..."
        echo "Using timezone: $TIMEZONE"
        podman build -t claude-code --build-arg TD="$TIMEZONE" "$DEVCONTAINER_DIR"
        ;;
    start)
        echo "Starting container..."
        ensure_claude_dir
        run_container "detached" "$CONTAINER_NAME"
        ;;
    run)
        echo "Running interactive container..."
        ensure_claude_dir
        run_container "interactive" "" "zsh"
        ;;
    exec)
        echo "Executing in container..."
        if [ $# -eq 0 ]; then
            # No command provided, use zsh by default
            podman exec -it "$CONTAINER_NAME" zsh
        else
            # Command provided, use it instead of the default
            podman exec -it "$CONTAINER_NAME" "$@"
        fi
        ;;
    stop)
        echo "Stopping container..."
        podman stop "$CONTAINER_NAME"
        ;;
    *)
        echo "Error: Unknown command '$command'"
        usage
        ;;
esac
