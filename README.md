# Claude Container

A simple container script for running Claude CLI.

## Installation

1. Clone this repository
2. Install

    ```bash
    # Add alias to your shell config
    alias claude-container=$(pwd)/claude-container

    # Or add to bin
    sudo cp claude-container /usr/local/bin
    ```

## Usage

```text
Usage: claude-container [run|help|build|start|exec|stop|rm] [options]

Run from within a project directory

Simple Commands:
  run         Run an interactive container that removes itself on exit (default command: claude)
  help        Displays help

More Commands:
  build       Build the container image
  start       Start a detached container (optional env var CONTAINER_NAME. default: parent-dir/current-dir)
  exec        Execute a command in a running container (default: zsh)
  stop        Stop a running container
  rm          Remove a stopped container
```

## Notes

- Creates a hidden `.claude` directory, which holds local settings, configuration and command history.
  You may want Git to ignore some or all of these. Eg, ignore all but settings:

  ```bash
  echo '/.claude' >> .gitignore
  echo '!/.claude/settings.local.json' >> .gitignore
  ```
