# Dotfiles

My personal Windows configuration files — GlazeWM window manager, Zebar status bar, Bash shell, and oh-my-posh prompt theme.

## Quick Install

Run in PowerShell (no cloning required):

```powershell
irm https://raw.githubusercontent.com/Ruimmp/dotfiles/refs/heads/windows/install.ps1 | iex
```

The installer lets you pick which components to install, checks for dependencies, backs up existing configs, and cleans up after itself.

## What's Included

### GlazeWM — Tiling Window Manager

Config located at `~/.glzr/glazewm/config.yaml` after install.

**Highlights:**
- Rounded corners + subtle glow on focused window
- `alt+arrow` — focus direction
- `alt+ctrl+arrow` — move window
- `alt+shift+arrow` — resize window
- `alt+f` — toggle fullscreen · `alt+shift+f` — toggle float
- `alt+q` — close window
- `alt+1`–`9` — switch workspace · `alt+shift+1`–`9` — move to workspace
- `alt+b` — Brave · `alt+shift+b` — Brave incognito
- `alt+e` — Explorer
- `alt+shift+z` — restart Zebar

### Zebar — Status Bar (ruimmp-dash)

Custom React-based Zebar widget installed to `~/.glzr/zebar/ruimmp-dash/`.

Requires Node.js for the build step (handled automatically by the installer).

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
    config.sh                 # LANG, HISTSIZE, etc.
  functions/
    ssh_connect.sh            # interactive SSH host picker
    docker.sh                 # docker nuke / docker redo helpers
    compress.sh               # ffmpeg MP4 compression helper
    utils.sh                  # mkcd, open, mate
    venv_manager.sh           # setup_venv — create/activate Python venv
```

**Notable aliases:**

| Alias | Command |
|---|---|
| `reload` | `source ~/.bashrc` |
| `projects` | `cd ~/Projects` |
| `ip` | `ipconfig` |
| `ports` | `netstat -ano \| findstr LISTENING` |
| `ssh` | Interactive SSH host picker |
| `docker.nuke` | Remove all containers, images, volumes, networks |
| `docker.redo` | `docker compose down -v` then `up -d` |
| `commit` | `git add . && git commit -m "update" && git push` |

### oh-my-posh — Prompt Theme

Custom theme installed to `~/.oh-my-posh/themes/ruimmp.omp.json`.

The `.bash/.bashrc` automatically loads it via:
```bash
eval "$(oh-my-posh init bash --config ~/.oh-my-posh/themes/ruimmp.omp.json)"
```

Prompt shows: shell name · username · current folder · git status + stash · execution time  
Right side shows: Python venv · Node.js + package manager · Ruby · Go · OS

## Requirements

| Component | Requirement |
|---|---|
| GlazeWM config | [GlazeWM](https://github.com/glzr-io/glazewm) |
| Zebar theme | [Zebar](https://github.com/glzr-io/zebar) + [Node.js](https://nodejs.org/) |
| Bash config | [Git for Windows](https://git-scm.com/) (Git Bash) |
| oh-my-posh theme | [oh-my-posh](https://ohmyposh.dev/) + a [Nerd Font](https://www.nerdfonts.com/) |

Quick install via winget:
```powershell
winget install glzr-io.glazewm glzr-io.zebar Git.Git JanDeDobbeleer.OhMyPosh OpenJS.NodeJS.LTS
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
   Copy-Item zebar\ruimmp-dash $env:USERPROFILE\.glzr\zebar\ruimmp-dash -Recurse -Force
   cd $env:USERPROFILE\.glzr\zebar\ruimmp-dash && npm install && npm run build
   ```

4. Bash dotfiles:
   ```powershell
   Copy-Item bash\.bashrc      $env:USERPROFILE\.bashrc      -Force
   Copy-Item bash\.bash_profile $env:USERPROFILE\.bash_profile -Force
   Copy-Item bash\.inputrc     $env:USERPROFILE\.inputrc     -Force
   Copy-Item bash\.bash        $env:USERPROFILE\.bash        -Recurse -Force
   ```

5. oh-my-posh theme:
   ```powershell
   Copy-Item oh-my-posh\themes\ruimmp.omp.json $env:USERPROFILE\.oh-my-posh\themes\ruimmp.omp.json -Force
   ```

## License

[MIT](LICENSE)
