# 🪟 Dotfiles - Windows

My personal Windows configuration files: GlazeWM tiling window manager, Zebar status bar, Git Bash shell, oh-my-posh prompt theme, Windows Terminal, and startup scripts.

---

## Table of Contents

- [Quick Install](#quick-install)
- [Requirements](#requirements)
- [Components](#components)
  - [GlazeWM](#glazewm---tiling-window-manager)
  - [Zebar](#zebar---status-bar)
  - [Bash Shell](#bash-shell-configuration)
  - [oh-my-posh](#oh-my-posh---prompt-theme)
  - [Windows Terminal](#windows-terminal)
  - [Startup Scripts](#startup-scripts)
- [Manual Installation](#manual-installation)
- [Troubleshooting](#troubleshooting)
- [License](#license)

---

## 🚀 Quick Install

Run in PowerShell - no cloning required:

```powershell
irm https://raw.githubusercontent.com/Ruimmp/dotfiles/refs/heads/windows/install.ps1 | iex
```

This downloads the script, shows an interactive menu, and installs your chosen components. The installer backs up any existing configs before overwriting.

### Install specific components

Because PowerShell cannot pass parameters through a pipe, download the script first:

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

---

## 📋 Requirements

Install everything at once via winget:

```powershell
winget install glzr-io.glazewm glzr-io.zebar Git.Git JanDeDobbeleer.OhMyPosh OpenJS.NodeJS.LTS Microsoft.WindowsTerminal
```

| Component        | Requirement                                                                                          |
| ---------------- | ---------------------------------------------------------------------------------------------------- |
| GlazeWM config   | [GlazeWM](https://github.com/glzr-io/glazewm)                                                        |
| Zebar pack       | [Zebar](https://github.com/glzr-io/zebar) v3+ · [Node.js](https://nodejs.org/) (to build the widget) |
| Bash config      | [Git for Windows](https://git-scm.com/) (provides Git Bash)                                          |
| oh-my-posh theme | [oh-my-posh](https://ohmyposh.dev/) · [Hack Nerd Font](https://www.nerdfonts.com/)                   |
| Windows Terminal | [Windows Terminal](https://aka.ms/terminal)                                                          |

---

## Components

### 🪟 GlazeWM - Tiling Window Manager

Config installed to `~/.glzr/glazewm/config.yaml`.

#### ⌨️ Keybindings

| Binding                        | Action                       |
| ------------------------------ | ---------------------------- |
| `alt+left/right/up/down`       | Focus window in direction    |
| `alt+ctrl+left/right/up/down`  | Move window in direction     |
| `alt+shift+left/right/up/down` | Resize window                |
| `alt+f`                        | Toggle fullscreen            |
| `alt+shift+f`                  | Toggle floating              |
| `alt+q`                        | Close focused window         |
| `alt+1` - `alt+9`              | Switch to workspace          |
| `alt+shift+1` - `alt+shift+9`  | Move window to workspace     |
| `alt+b`                        | Open Brave browser           |
| `alt+shift+b`                  | Open Brave in incognito mode |
| `alt+e`                        | Open File Explorer           |
| `alt+shift+z`                  | Restart Zebar                |

#### ✨ Visual settings

- 10px gaps between windows and screen edges
- Rounded window corners
- Subtle glow effect on the focused window
- No border decoration on unfocused windows

#### 🎮 Process ignore rules

The following game processes are excluded from tiling (treated as floating):

- `RiotClientServices.exe` (Riot Client)
- `VALORANT.exe`
- `LeagueClient.exe` / `League of Legends.exe`
- `Warface.exe`

#### Customisation

Edit `~/.glzr/glazewm/config.yaml` directly. Changes apply after restarting GlazeWM (`alt+shift+r` by default, or from the system tray).

---

### 📊 Zebar - Status Bar

Pack installed to `~/.glzr/zebar/ruimmp/`. The ruimmp pack is set as the sole startup config in `~/.glzr/zebar/settings.json`.

#### Pack structure

```
~/.glzr/zebar/ruimmp/
  zpack.json            # pack manifest (name, version, widget list)
  V1/
    dist/               # built output loaded by Zebar at runtime
    src/
      main.jsx          # widget entry - providers + layout
      styles.css        # CSS with custom property theming
      components/       # PowerMenu, MediaWidget, WebSearch, Shortcut, Settings
      hooks/            # useTheme.js - maps theme.js to CSS variables
      utils/            # throttle helper
    config/
      config.js         # feature toggles (enable/disable widgets)
      theme.js          # colors, fonts, layout values
    package.json
    vite.config.js
```

#### Widget layout

A full-width top bar, 40px tall, with three regions:

| Region | Content                                                                                 |
| ------ | --------------------------------------------------------------------------------------- |
| Left   | Windows logo · hostname · OS version                                                    |
| Center | Workspace buttons (GlazeWM integration)                                                 |
| Right  | Media player · date/time · weather · CPU · RAM · battery · keyboard layout · power menu |

#### Customising config.js

`V1/config/config.js` controls which widgets are active and their behaviour. Key options:

```js
media: { enabled: true, showControlsOnHover: true }
search: { enabled: false, explorerPath: "chrome" }
shortcuts: { enabled: false }
dateTime: { dateFormat: "ddd, D MMM", timeFormat: "HH:mm" }
keyboard: { enabled: true, layoutOverride: "Swiss Fr" }
powerMenu: { enabled: true, options: ["shutdown", "restart", "sleep"] }
systemStats: { cpu: true, memory: true, warningThreshold: 80 }
battery: { enabled: true, warningThreshold: 20 }
weather: { units: "celsius" }
```

#### Customising theme.js

`V1/config/theme.js` controls colours, fonts, and geometry. Key values:

```js
colors: {
  primary: "rgba(100, 105, 110, 0.95)",   // container background
  background: "linear-gradient(...)",      // bar background
  text: "rgba(255, 255, 255, 0.92)",
}
fonts: { size: "13px", family: "monospace" }
layout: { borderRadius: "12px", barHeight: "36px", blurAmount: "16px" }
```

#### 🔨 Rebuild after editing

The widget is a React/Vite app. After editing any source or config file, rebuild:

```powershell
cd ~/.glzr/zebar/ruimmp/V1
npm install   # only needed after package.json changes
npm run build
```

Then restart Zebar (or use `alt+shift+z` in GlazeWM).

---

### 🐚 Bash Shell Configuration

Installed to your home directory (`~`).

#### 📂 File structure

```
~/.bashrc                     # entry point - sources ~/.bash/.bashrc
~/.bash_profile               # Git Bash login profile
~/.inputrc                    # readline: disables terminal bell
~/.bash/
  .bashrc                     # init: loads oh-my-posh, settings, functions, aliases
  aliases.sh                  # all shell aliases
  settings/
    config.sh                 # LANG, HISTSIZE, history dedup settings
  functions/
    ssh_connect.sh            # interactive SSH host picker from ~/.ssh/config
    docker.sh                 # docker nuke / docker redo helpers
    compress.sh               # ffmpeg MP4 compression helper
    utils.sh                  # mkcd, open (Explorer), mate (Notepad)
    venv_manager.sh           # setup_venv - create/activate Python venv
```

#### Aliases

| Alias         | Expands to                                              |
| ------------- | ------------------------------------------------------- |
| `reload`      | `source ~/.bashrc`                                      |
| `ll`          | `ls -lh`                                                |
| `la`          | `ls -la`                                                |
| `projects`    | `cd ~/Projects`                                         |
| `home`        | `cd ~`                                                  |
| `cls`         | `clear`                                                 |
| `ports`       | `netstat -ano \| findstr LISTENING`                     |
| `hosts`       | Open `C:\Windows\System32\drivers\etc\hosts` in Notepad |
| `ssh`         | Interactive SSH host picker (see below)                 |
| `docker.nuke` | Remove all containers, images, volumes, networks, cache |
| `docker.redo` | `docker compose down -v` then `docker compose up -d`    |

#### ⚡ Functions

**`ssh_connect.sh`** - Overrides `ssh` with an interactive picker. Reads `~/.ssh/config`, displays a numbered list of hosts, and connects to your choice.

**`docker.sh`** - Overrides the `docker` command so that:

- `docker nuke` - stops all containers, removes all images, volumes, networks, and build cache
- `docker redo` - runs `docker compose down -v` followed by `docker compose up -d`
- All other `docker` subcommands pass through normally

**`compress.sh`** - `compress <input_file> [output_dir]` re-encodes a video to MP4 with libx264. Prompts before overwriting.

**`utils.sh`**:

- `mkcd <dir>` - create directory and immediately `cd` into it
- `open [path]` - open a path (or current directory) in File Explorer
- `mate <file>` - open a file in Notepad (falls back to `notepad.exe`)

**`venv_manager.sh`** - `setup_venv [dir]` creates a Python virtual environment, activates it, and installs `requirements.txt` if present.

---

### 🎨 oh-my-posh - Prompt Theme

Theme installed to `~/.oh-my-posh/themes/ruimmp.omp.json`.

#### Prompt layout

**Left side (primary prompt):**

```
 bash  username  ~/current/folder  ‹ main ●2 +1 ↑3  stash:1  12.3s
❯
```

| Segment        | Shows                                     |
| -------------- | ----------------------------------------- |
| Shell name     | `bash`                                    |
| Username       | current user                              |
| Path           | abbreviated working directory             |
| Git status     | branch · modified · staged · ahead/behind |
| Git stash      | stash count (when non-zero)               |
| Execution time | duration of last command (when > 2s)      |

**Right side:**

| Segment     | Shows                                         |
| ----------- | --------------------------------------------- |
| Python venv | active virtualenv name                        |
| Node.js     | version + package manager (npm/yarn/pnpm/bun) |
| Ruby        | version                                       |
| Go          | version                                       |
| OS          | Windows icon                                  |

#### Activation

The theme is loaded automatically via `~/.bash/.bashrc`:

```bash
eval "$(oh-my-posh init bash --config ~/.oh-my-posh/themes/ruimmp.omp.json)"
```

After installing the theme, open a new Git Bash session to see it. Requires [Hack Nerd Font](https://www.nerdfonts.com/) in your terminal.

---

### 🖥️ Windows Terminal

Settings installed to `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json`.

#### Defaults

| Setting            | Value                |
| ------------------ | -------------------- |
| Default profile    | Git Bash             |
| Font               | Hack Nerd Font, 12pt |
| Color scheme       | Ruimmp               |
| Starting directory | `%USERPROFILE%`      |

#### 🎨 Color scheme - Ruimmp

Dark blue base, One Dark-inspired palette:

| Color      | Value     |
| ---------- | --------- |
| Background | `#001B26` |
| Foreground | `#ABB2BF` |
| Black      | `#282C34` |
| Red        | `#E06C75` |
| Green      | `#98C379` |
| Yellow     | `#E5C07B` |
| Blue       | `#61AFEF` |
| Purple     | `#C678DD` |
| Cyan       | `#56B6C2` |
| White      | `#ABB2BF` |

#### ⌨️ Keybindings

| Shortcut            | Action                        |
| ------------------- | ----------------------------- |
| `ctrl+t`            | New tab                       |
| `ctrl+w`            | Close pane                    |
| `ctrl+d`            | Split pane right              |
| `ctrl+shift+d`      | Split pane down               |
| `ctrl+1` - `ctrl+8` | Switch to tab 1-8             |
| `ctrl+h/j/k/l`      | Focus pane left/down/up/right |
| `ctrl+f`            | Find                          |
| `ctrl+e`            | Toggle dropdown               |

#### Adding profiles

The settings include only PowerShell, CMD, and Git Bash. To add your WSL distro, open Windows Terminal settings (`ctrl+,`) and add it through the UI, or manually add a profile entry to `settings.json`.

---

### ⚡ Startup Scripts

Script installed to `~/.startup/`. The installer also registers the Task Scheduler task automatically - no manual setup needed.

| Script                       | Purpose                                                                   |
| ---------------------------- | ------------------------------------------------------------------------- |
| `install-hack-nerd-font.ps1` | Registers Hack Nerd Font TTFs from `C:\Fonts\HackNerdFont` at every logon |

#### Why at logon, not just once?

On some machines Windows silently drops custom font registrations after updates or profile changes. When that happens, terminals fall back to the system default font and lose all icon/glyph rendering. Running the check at every logon guarantees the font stays registered regardless.

#### Task Scheduler task

The installer creates **Hack Nerd Font - Startup Check** automatically:

- Trigger: at logon
- Runs as current user with highest privileges (admin)
- Window: hidden

If the automatic registration failed (e.g. the installer wasn't run as admin), see [`startup/README.md`](startup/README.md) for manual Task Scheduler steps.

---

## 🔧 Manual Installation

1. Clone the repository:

   ```powershell
   git clone https://github.com/Ruimmp/dotfiles.git -b windows
   cd dotfiles
   ```

2. GlazeWM:

   ```powershell
   New-Item -ItemType Directory -Force "$env:USERPROFILE\.glzr\glazewm"
   Copy-Item glazewm\config.yaml "$env:USERPROFILE\.glzr\glazewm\config.yaml" -Force
   ```

3. Zebar:

   ```powershell
   Copy-Item zebar\ruimmp "$env:USERPROFILE\.glzr\zebar\ruimmp" -Recurse -Force
   cd "$env:USERPROFILE\.glzr\zebar\ruimmp\V1"
   npm install
   npm run build
   ```

   Then set it as the default in `~/.glzr/zebar/settings.json`:

   ```json
   {
     "$schema": "https://github.com/glzr-io/zebar/raw/v3.1.1/resources/settings-schema.json",
     "startupConfigs": [{ "pack": "ruimmp", "widget": "V1", "preset": "default" }]
   }
   ```

4. Bash dotfiles:

   ```powershell
   Copy-Item bash\.bashrc       "$env:USERPROFILE\.bashrc"       -Force
   Copy-Item bash\.bash_profile "$env:USERPROFILE\.bash_profile" -Force
   Copy-Item bash\.inputrc      "$env:USERPROFILE\.inputrc"      -Force
   Copy-Item bash\.bash         "$env:USERPROFILE\.bash"         -Recurse -Force
   ```

5. oh-my-posh theme:

   ```powershell
   New-Item -ItemType Directory -Force "$env:USERPROFILE\.oh-my-posh\themes"
   Copy-Item oh-my-posh\themes\ruimmp.omp.json "$env:USERPROFILE\.oh-my-posh\themes\ruimmp.omp.json" -Force
   ```

6. Windows Terminal:

   ```powershell
   $dest = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
   Copy-Item windows-terminal\settings.json "$dest\settings.json" -Force
   ```

7. Startup scripts:
   ```powershell
   New-Item -ItemType Directory -Force "$env:USERPROFILE\.startup"
   Copy-Item startup\* "$env:USERPROFILE\.startup\" -Force
   ```

---

## 🩹 Troubleshooting

**GlazeWM config not loading**
Verify the config path: `~/.glzr/glazewm/config.yaml`. Check the GlazeWM tray icon for error details, or run `glazewm --config <path>` in PowerShell.

**Zebar not showing the ruimmp bar**
Make sure `~/.glzr/zebar/settings.json` contains the ruimmp entry in `startupConfigs`. Restart Zebar from the system tray or via `alt+shift+z`.

**Zebar widget shows a blank bar / JS error**
The `dist/` folder must exist. Run `npm run build` inside `~/.glzr/zebar/ruimmp/V1/`.

**oh-my-posh prompt not loading**
Ensure `oh-my-posh` is on your PATH (`where oh-my-posh` in Git Bash). If it's installed via winget, restart Git Bash after installation. Also confirm the theme path matches `~/.oh-my-posh/themes/ruimmp.omp.json`.

**Icons show as squares / question marks**
Install Hack Nerd Font from `~/.startup/install-hack-nerd-font.ps1` (run as Administrator), or download it from [nerdfonts.com](https://www.nerdfonts.com/). Then set the font in your terminal.

**Windows Terminal: Git Bash profile missing**
Git for Windows must be installed. After installing it, the Git Bash profile should appear automatically. If it doesn't, add a profile manually with the command `C:\Program Files\Git\bin\bash.exe --login -i`.

**Execution policy error**
If you see a script execution error, run:

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

---

## License

[MIT](LICENSE)
