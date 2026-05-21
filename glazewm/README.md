# 🪟 GlazeWM Config

Tiling window manager configuration for [GlazeWM](https://github.com/glzr-io/glazewm).

Installed to `~/.glzr/glazewm/config.yaml`.

## ⌨️ Keybindings

| Binding                        | Action                    |
| ------------------------------ | ------------------------- |
| `alt+left/right/up/down`       | Focus window in direction |
| `alt+ctrl+left/right/up/down`  | Move window in direction  |
| `alt+shift+left/right/up/down` | Resize window             |
| `alt+f`                        | Toggle fullscreen         |
| `alt+shift+f`                  | Toggle floating           |
| `alt+q`                        | Close focused window      |
| `alt+1` - `alt+9`              | Switch to workspace       |
| `alt+shift+1` - `alt+shift+9`  | Move window to workspace  |
| `alt+t`                        | Open Windows Terminal     |
| `alt+b`                        | Open Brave browser        |
| `alt+shift+b`                  | Open Brave (incognito)    |
| `alt+e`                        | Open File Explorer        |
| `alt+shift+z`                  | Restart Zebar             |

## ✨ Visual

- 10px gaps between windows and screen edges
- Rounded corners on all windows
- Subtle glow on the focused window, no border on unfocused
- Zebar reserves 40px at the top (gap offset)

## 🎮 Ignored processes

These run outside the tiling grid (floating, no tile):

| Process                                      | App               |
| -------------------------------------------- | ----------------- |
| `RiotClientServices.exe`                     | Riot Client       |
| `VALORANT.exe`                               | VALORANT          |
| `LeagueClient.exe` / `League of Legends.exe` | League of Legends |
| `Warface.exe`                                | Warface           |

## ⚙️ Customisation

Edit `config.yaml` directly. Restart GlazeWM to apply (`alt+shift+r` or tray icon - Restart).

To add a new keybinding:

```yaml
keybindings:
  - commands: ["exec", "shell-exec", "notepad.exe"]
    bindings: ["alt+n"]
```

To ignore a new process:

```yaml
window_rules:
  - commands: ["ignore"]
    match:
      - window_process: { equals: "YourProcess.exe" }
```
