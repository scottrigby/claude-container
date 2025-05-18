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
  start       Start a detached container (optional env var CONTAINER_NAME. default: parent-dir/current-dir)
  run         Run an interactive container that removes itself on exit (default command: claude)
  exec        Execute a command in a running container (default: zsh)
  stop        Stop a running container
  help        Displays help
```

## Notes

- Creates a hidden `.claude` directory, which holds local settings, configuration and command history.
  You may want Git to ignore some or all of these. Eg, ignore all but settings:

  ```bash
  echo '/.claude' >> .gitignore
  echo '!/.claude/settings.local.json' >> .gitignore
  ```
