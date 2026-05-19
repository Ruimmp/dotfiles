# Dotfiles

My personal configuration files for various applications and systems across different platforms.

## Platform-Specific Branches

| Platform | Status | Branch |
|---|---|---|
| **Windows** | Available | [`windows`](https://github.com/Ruimmp/dotfiles/tree/windows) |
| **Linux** | Coming soon | — |
| **macOS** | Coming soon | — |

## Windows

Includes: GlazeWM window manager, Zebar status bar, Bash shell config, and oh-my-posh prompt theme.

### Quick Install

Run in PowerShell (no cloning required):

```powershell
irm https://raw.githubusercontent.com/Ruimmp/dotfiles/refs/heads/windows/install.ps1 | iex
```

The installer lets you pick which components to install, checks for dependencies, backs up existing configs, and cleans up after itself.

### What's included

- **GlazeWM** — tiling window manager config with keybindings, rounded borders, and game process rules
- **Zebar (ruimmp-dash)** — custom React status bar widget
- **Bash shell** — aliases, functions (ssh picker, docker helpers, venv manager), oh-my-posh init
- **oh-my-posh theme** — custom multi-line prompt with git, runtime, and OS segments

See the [Windows branch README](https://github.com/Ruimmp/dotfiles/tree/windows#readme) for full documentation and manual install steps.

## License

[MIT](LICENSE)
