# Dotfiles

My personal Windows configuration files — GlazeWM window manager, Zebar status bar, Bash shell, oh-my-posh prompt theme, Windows Terminal, and startup scripts.

## Quick Install

Run in PowerShell (no cloning required — interactive menu):

```powershell
irm https://raw.githubusercontent.com/Ruimmp/dotfiles/refs/heads/windows/install.ps1 | iex
```

To install specific components without the menu, download the script first:

```powershell
irm https://raw.githubusercontent.com/Ruimmp/dotfiles/refs/heads/windows/install.ps1 -OutFile install.ps1

.\install.ps1 -GlazeWM              # GlazeWM config only
.\install.ps1 -Zebar                # Zebar pack only
.\install.ps1 -Bash                 # Bash config + oh-my-posh theme
.\install.ps1 -Terminal             # Windows Terminal settings
.\install.ps1 -Startup              # Startup scripts
.\install.ps1 -GlazeWM -Zebar -Bash # Combine any flags
.\install.ps1 -All                  # Everything at once
```

The installer backs up any existing configs with a timestamp before overwriting.

## What's Included

### GlazeWM — Tiling Window Manager

Config installed to `~/.glzr/glazewm/config.yaml`.

| Binding | Action |
|---|---|
| `alt+arrow` | Focus window |
| `alt+ctrl+arrow` | Move window |
| `alt+shift+arrow` | Resize window |
| `alt+f` | Toggle fullscreen |
| `alt+shift+f` | Toggle floating |
| `alt+q` | Close window |
| `alt+1`–`9` | Switch workspace |
| `alt+shift+1`–`9` | Move window to workspace |
| `alt+b` | Open Brave |
| `alt+shift+b` | Open Brave incognito |
| `alt+e` | Open Explorer |
| `alt+shift+z` | Restart Zebar |

Visual: rounded corners with subtle glow on focused window, 10px gaps.
Game process rules: Riot Client, VALORANT, League of Legends, Warface are ignored (no tiling).

### Zebar — Status Bar (ruimmp pack)

Zebar v3 pack installed to `~/.glzr/zebar/ruimmp/`.

Built with React + Vite. The widget (`V1`) is a full-width top bar with:
- **Left**: Windows icon + hostname + OS version (optional app shortcuts)
- **Center**: Workspace buttons
- **Right**: Media player, date/time, weather, CPU, RAM, battery, keyboard layout, power menu

Customise via `V1/config/config.js` (features) and `V1/config/theme.js` (colors/layout).

To build after editing:
```powershell
cd ~/.glzr/zebar/ruimmp/V1
npm install
npm run build
```

### Bash Shell Configuration

Installed to your home directory (`~`). Structure:

```
~/.bashrc                     # entry point, sources ~/.bash/.bashrc
~/.bash_profile               # Git Bash profile
~/.inputrc                    # readline settings (no bell)
~/.bash/
  .bashrc                     # init: oh-my-posh + loaders
  aliases.sh                  # shell aliases
  settings/
    config.sh                 # LANG, HISTSIZE, history dedup
  functions/
    ssh_connect.sh            # interactive SSH host picker from ~/.ssh/config
    docker.sh                 # docker nuke / docker redo helpers
    compress.sh               # ffmpeg MP4 compression helper
    utils.sh                  # mkcd, open (explorer), mate (notepads)
    venv_manager.sh           # setup_venv — create/activate Python venv
```

**Notable aliases:**

| Alias | Command |
|---|---|
| `reload` | `source ~/.bashrc` |
| `projects` | `cd ~/Projects` |
| `ports` | `netstat -ano \| findstr LISTENING` |
| `ssh` | Interactive SSH host picker |
| `docker.nuke` | Remove all containers, images, volumes, networks |
| `docker.redo` | `docker compose down -v` then `up -d` |

### oh-my-posh — Prompt Theme

Custom theme installed to `~/.oh-my-posh/themes/ruimmp.omp.json`.

Prompt shows: shell name · username · current folder · git status + stash · execution time
Right side shows: Python venv · Node.js + package manager · Ruby · Go · OS

### Windows Terminal

Settings installed to the Windows Terminal `LocalState` directory.

- **Default profile**: Git Bash
- **Default font**: Hack Nerd Font, 12pt
- **Color scheme**: Ruimmp (dark blue base, One Dark palette)
- **Key bindings**: `ctrl+t` new tab, `ctrl+w` close pane, `ctrl+1`–`8` switch tabs, pane controls

### Startup Scripts

Scripts installed to `~/.startup/`:

| Script | Purpose |
|---|---|
| `install-hack-nerd-font.ps1` | Registers Hack Nerd Font TTFs from `C:\Fonts\HackNerdFont` |
| `raycast-watchdog.ps1` | Keeps Raycast running; polls every 15 seconds |

Register via Task Scheduler (run at logon, hidden) if you want them to execute automatically.

## Requirements

| Component | Requirement |
|---|---|
| GlazeWM config | [GlazeWM](https://github.com/glzr-io/glazewm) |
| Zebar pack | [Zebar](https://github.com/glzr-io/zebar) v3+ + [Node.js](https://nodejs.org/) |
| Bash config | [Git for Windows](https://git-scm.com/) (Git Bash) |
| oh-my-posh theme | [oh-my-posh](https://ohmyposh.dev/) + [Hack Nerd Font](https://www.nerdfonts.com/) |
| Windows Terminal | [Windows Terminal](https://aka.ms/terminal) |

Quick install via winget:
```powershell
winget install glzr-io.glazewm glzr-io.zebar Git.Git JanDeDobbeleer.OhMyPosh OpenJS.NodeJS.LTS Microsoft.WindowsTerminal
```

## Manual Installation

1. Clone the repository:
   ```powershell
   git clone https://github.com/Ruimmp/dotfiles.git -b windows
   cd dotfiles
   ```

2. GlazeWM:
   ```powershell
   Copy-Item glazewm\config.yaml $env:USERPROFILE\.glzr\glazewm\config.yaml -Force
   ```

3. Zebar:
   ```powershell
   Copy-Item zebar\ruimmp $env:USERPROFILE\.glzr\zebar\ruimmp -Recurse -Force
   cd $env:USERPROFILE\.glzr\zebar\ruimmp\V1
   npm install && npm run build
   ```

4. Bash dotfiles:
   ```powershell
   Copy-Item bash\.bashrc       $env:USERPROFILE\.bashrc       -Force
   Copy-Item bash\.bash_profile $env:USERPROFILE\.bash_profile -Force
   Copy-Item bash\.inputrc      $env:USERPROFILE\.inputrc      -Force
   Copy-Item bash\.bash         $env:USERPROFILE\.bash         -Recurse -Force
   ```

5. oh-my-posh theme:
   ```powershell
   Copy-Item oh-my-posh\themes\ruimmp.omp.json $env:USERPROFILE\.oh-my-posh\themes\ruimmp.omp.json -Force
   ```

6. Windows Terminal:
   ```powershell
   Copy-Item windows-terminal\settings.json "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -Force
   ```

7. Startup scripts:
   ```powershell
   Copy-Item startup\* $env:USERPROFILE\.startup\ -Force
   ```

## License

[MIT](LICENSE)
