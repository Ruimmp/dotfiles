# Dotfiles

My personal configuration files for various applications and systems across different platforms.

## Platform-Specific Branches

| Platform    | Status      | Branch                                                       |
| ----------- | ----------- | ------------------------------------------------------------ |
| **Windows** | Available   | [`windows`](https://github.com/Ruimmp/dotfiles/tree/windows) |
| **Linux**   | Coming soon | —                                                            |
| **macOS**   | Coming soon | —                                                            |

## Windows

Includes: GlazeWM tiling window manager, Zebar v3 status bar (ruimmp pack), Git Bash shell, oh-my-posh prompt theme, Windows Terminal settings, and startup scripts.

### Quick Install

Run in PowerShell — no cloning required:

```powershell
irm https://raw.githubusercontent.com/Ruimmp/dotfiles/refs/heads/windows/install.ps1 | iex
```

The installer shows an interactive menu to pick components, checks dependencies, backs up existing configs, and cleans up after itself. To install specific components without the menu, download the script first:

```powershell
irm https://raw.githubusercontent.com/Ruimmp/dotfiles/refs/heads/windows/install.ps1 -OutFile install.ps1

.\install.ps1 -GlazeWM    # GlazeWM config only
.\install.ps1 -Zebar      # Zebar pack only
.\install.ps1 -Bash       # Bash config + oh-my-posh theme
.\install.ps1 -Terminal   # Windows Terminal settings
.\install.ps1 -Startup    # Startup scripts
.\install.ps1 -All        # Everything at once
```

### What's included

- **GlazeWM** — tiling window manager with keybindings, rounded corners + glow on focused window, game process ignore rules
- **Zebar (ruimmp pack)** — React/Vite status bar with workspaces, media, weather, CPU/RAM, battery, keyboard layout, and power menu
- **Bash shell** — modular config with aliases, SSH host picker, docker helpers, venv manager, and ffmpeg compress helper
- **oh-my-posh** — custom multi-line prompt with git status, execution time, Python/Node/Ruby/Go runtime segments
- **Windows Terminal** — Git Bash as default, Hack Nerd Font, Ruimmp dark color scheme, custom keybindings
- **Startup scripts** — Hack Nerd Font logon check (auto-registered in Task Scheduler)

See the [Windows branch README](https://github.com/Ruimmp/dotfiles/tree/windows#readme) for full documentation, keybinding tables, customisation guides, and manual installation steps.

## License

[MIT](LICENSE)
