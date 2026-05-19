# 🎨 oh-my-posh Theme - ruimmp

Custom [oh-my-posh](https://ohmyposh.dev/) prompt theme.

Installed to `~/.oh-my-posh/themes/ruimmp.omp.json`.

## Prompt layout

```
 bash  username  ~/current/path  ‹ main ●2 +1 ↑3  stash:1  12.3s
❯
```

**Left (primary prompt)**

| Segment   | Shows                                      |
| --------- | ------------------------------------------ |
| Shell     | `bash`                                     |
| User      | Current username                           |
| Path      | Abbreviated working directory              |
| Git       | Branch · modified · staged · ahead/behind  |
| Stash     | Stash count (hidden when 0)                |
| Exec time | Duration of last command (shown when > 2s) |

**Right (inline)**

| Segment     | Shows                              |
| ----------- | ---------------------------------- |
| Python venv | Active virtualenv name             |
| Node.js     | Version + detected package manager |
| Ruby        | Version                            |
| Go          | Version                            |
| OS          | Windows icon                       |

## ⚡ Activation

Loaded automatically by `~/.bash/.bashrc`. No manual setup needed after installing.

Requires **Hack Nerd Font** - install via `~/.startup/install-hack-nerd-font.ps1` or download from [nerdfonts.com](https://www.nerdfonts.com/).

## ⚙️ Customisation

Edit `~/.oh-my-posh/themes/ruimmp.omp.json` directly, then open a new shell session to see changes. Full segment reference at [ohmyposh.dev/docs/segments](https://ohmyposh.dev/docs/segments/overview).
