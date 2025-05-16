# Claude Container

A simple container script for running Claude CLI.

## Installation

1. Clone this repository
2. Add alias to your shell config:

```bash
alias claude-container=$(pwd)/claude-container
```

## Usage

```bash
Usage: claude-container [build|start|run|exec|stop|help] [options]

Commands:
  build       Build the container image
  start       Start a detached container
  run         Run an interactive container that removes itself on exit (default command: claude)
  exec        Execute a command in a running container (default: zsh)
  stop        Stop a running container
  help        Displays help
```

## Notes

- The container uses the current directory name to generate a unique container name
- Configuration is stored in `./claude/config`
- Command history is preserved in `./claude/commandhistory`
