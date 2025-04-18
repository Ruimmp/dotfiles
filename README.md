# Windows Dotfiles

My personal Windows configuration files for GlazeWM window manager and Zebar status bar.

## 🚀 Features

- **GlazeWM Configuration** - Tiling window manager setup with optimized keybindings
- **Ruimmp-Dash** - Custom Zebar theme with system monitoring, media controls, and more

## 💻 One-Click Installation

Run the following command in PowerShell to install:

```powershell
irm https://raw.githubusercontent.com/Ruimmp/dotfiles/refs/heads/windows/install.ps1 | iex
```

The installer will:

1. Let you choose which components to install
2. Check for required dependencies
3. Install the selected configurations
4. Clean up automatically

## 📦 Manual Installation

If you prefer to manually install:

1. Clone this repository:

   ```powershell
   git clone https://github.com/Ruimmp/dotfiles.git -b windows
   cd dotfiles
   ```

2. For GlazeWM configuration:

   ```powershell
   Copy-Item -Path "glazewm\config.yaml" -Destination "$env:USERPROFILE\.glzr\glazewm\config.yaml" -Force
   ```

3. For Zebar theme:
   ```powershell
   Copy-Item -Path "zebar\ruimmp-dash" -Destination "$env:USERPROFILE\.glzr\zebar\ruimmp-dash" -Recurse -Force
   ```

## 📋 Requirements

- [GlazeWM](https://github.com/glzr-io/glazewm) - Tiling window manager
- [Zebar](https://github.com/glzr-io/zebar) - Status bar
- [Node.js](https://nodejs.org/) - For building Zebar theme
- [Nerd Fonts](https://www.nerdfonts.com/) - For icons

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
