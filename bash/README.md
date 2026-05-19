# Bash Shell Config

Modular Git Bash configuration with oh-my-posh prompt, aliases, and utility functions.

## File structure

```
bash/
  .bashrc           → ~/.bashrc          (entry point, sources ~/.bash/.bashrc)
  .bash_profile     → ~/.bash_profile    (Git Bash login profile)
  .inputrc          → ~/.inputrc         (readline: no bell)
  .bash/
    .bashrc                              (init: oh-my-posh + loaders)
    aliases.sh                           (all aliases)
    settings/
      config.sh                          (LANG, history settings)
    functions/
      ssh_connect.sh                     (interactive SSH picker)
      docker.sh                          (docker nuke/redo helpers)
      compress.sh                        (ffmpeg MP4 helper)
      utils.sh                           (mkcd, open, mate)
      venv_manager.sh                    (Python venv helper)
```

## Aliases

| Alias | Command |
|---|---|
| `reload` | `source ~/.bashrc` |
| `ll` | `ls -lh` |
| `la` | `ls -la` |
| `home` | `cd ~` |
| `projects` | `cd ~/Projects` |
| `cls` | `clear` |
| `ports` | `netstat -ano \| findstr LISTENING` |
| `hosts` | Open `/etc/hosts` in Notepad |
| `ssh` | Interactive SSH picker |
| `docker.nuke` | Wipe all containers, images, volumes, networks |
| `docker.redo` | `compose down -v` then `compose up -d` |

## Functions

### `ssh_connect.sh`
Overrides `ssh`. Reads `~/.ssh/config`, shows a numbered host list, connects to your pick. Any unrecognised argument falls through to the real `ssh`.

### `docker.sh`
Overrides `docker`:
- `docker nuke` — stops everything, removes all images/volumes/networks/build cache
- `docker redo` — `compose down -v` + `compose up -d`
- Everything else passes through to the real `docker`

### `compress.sh`
`compress <file> [output_dir]` — re-encodes a video to H.264 MP4 using ffmpeg. Prompts before overwriting.

### `utils.sh`
- `mkcd <dir>` — `mkdir -p` + `cd`
- `open [path]` — opens path (or `.`) in File Explorer
- `mate <file>` — opens file in Notepad (prefers `notepads.exe`, falls back to `notepad.exe`)

### `venv_manager.sh`
`setup_venv [dir]` — creates `.venv` with `python -m venv`, activates it, and installs `requirements.txt` if present.

## oh-my-posh

The prompt is loaded in `.bash/.bashrc`:
```bash
eval "$(oh-my-posh init bash --config ~/.oh-my-posh/themes/ruimmp.omp.json)"
```

See [`../oh-my-posh/README.md`](../oh-my-posh/README.md) for theme details.
