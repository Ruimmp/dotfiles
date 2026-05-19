# Windows Terminal Settings

Custom [Windows Terminal](https://aka.ms/terminal) configuration.

Installed to `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json`.

## Defaults

| Setting | Value |
|---|---|
| Default profile | Git Bash |
| Font | Hack Nerd Font, 12pt |
| Color scheme | Ruimmp |
| Starting directory | `%USERPROFILE%` |

## Color scheme — Ruimmp

Dark blue base with One Dark palette:

| Role | Color |
|---|---|
| Background | `#001B26` |
| Foreground | `#ABB2BF` |
| Black | `#282C34` |
| Red | `#E06C75` |
| Green | `#98C379` |
| Yellow | `#E5C07B` |
| Blue | `#61AFEF` |
| Purple | `#C678DD` |
| Cyan | `#56B6C2` |
| White | `#ABB2BF` |

## Key bindings

| Shortcut | Action |
|---|---|
| `ctrl+t` | New tab |
| `ctrl+w` | Close pane |
| `ctrl+d` | Split pane right |
| `ctrl+shift+d` | Split pane down |
| `ctrl+1` – `ctrl+8` | Switch to tab 1–8 |
| `ctrl+h` / `ctrl+l` | Focus pane left/right |
| `ctrl+j` / `ctrl+k` | Focus pane down/up |
| `ctrl+f` | Find |
| `ctrl+e` | Toggle dropdown |

## Profiles included

Only the three essentials are shipped — WSL distros vary per machine:

- **Git Bash** (default) — `C:\Program Files\Git\bin\bash.exe`
- **PowerShell** — Windows PowerShell 5.1
- **Command Prompt**

To add your WSL distro, open Settings (`ctrl+,`) and add a profile, or insert one in `settings.json`.

## Font

Requires **Hack Nerd Font**. Install it via the startup script or download from [nerdfonts.com](https://www.nerdfonts.com/). After installing, restart Windows Terminal.
