# Startup Scripts

Scripts that run at logon via Task Scheduler.

The installer (`install.ps1 -Startup`) copies the script to `~/.startup/` and registers the Task Scheduler task automatically. Admin rights are required.

## Scripts

### `install-hack-nerd-font.ps1`

Copies Hack Nerd Font TTF files from `C:\Fonts\HackNerdFont` to `C:\Windows\Fonts` and registers them in the registry.

**Why at startup?** On some machines, Windows silently drops custom font registrations after updates or profile changes. When that happens, terminals configured to use Hack Nerd Font fall back to the system default and lose all icon/glyph rendering. Running this at every logon guarantees the font is always registered, regardless of what Windows does in the background.

**Font files:** Download Hack Nerd Font from [nerdfonts.com](https://www.nerdfonts.com/font-downloads) and place the `.ttf` files in `C:\Fonts\HackNerdFont\`. The script exits silently if the source directory doesn't exist.

**Task Scheduler task:** `Hack Nerd Font - Startup Check`
- Trigger: At logon
- Run as: current user, with highest privileges
- Window: hidden

## Manual Task Scheduler setup

If the automatic registration failed, create the task manually:

1. Open **Task Scheduler** → **Create Task**
2. **General:** name it, check *Run whether user is logged on or not*, check *Hidden*, check *Run with highest privileges*
3. **Triggers:** New → *At log on*
4. **Actions:** New → Program: `powershell.exe`
   Arguments: `-WindowStyle Hidden -ExecutionPolicy Bypass -File "%USERPROFILE%\.startup\install-hack-nerd-font.ps1"`
5. Click OK and enter your password if prompted
