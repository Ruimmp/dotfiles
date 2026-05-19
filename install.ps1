<#
.SYNOPSIS
    Installation script for Windows dotfiles.
.DESCRIPTION
    Installs any combination of: GlazeWM config, Zebar pack, Bash shell config,
    oh-my-posh theme, Windows Terminal settings, and startup scripts.

    Interactive mode (no parameters): shows a menu.
    Parameter mode: installs only the specified components.

.EXAMPLE
    # Interactive — also works via: irm https://raw.githubusercontent.com/Ruimmp/dotfiles/refs/heads/windows/install.ps1 | iex
    .\install.ps1

.EXAMPLE
    # Install specific components
    .\install.ps1 -GlazeWM -Zebar
    .\install.ps1 -Bash
    .\install.ps1 -Terminal
    .\install.ps1 -Startup
    .\install.ps1 -All

.EXAMPLE
    # Download and run with parameters (parameters cannot be passed via irm | iex)
    irm https://raw.githubusercontent.com/Ruimmp/dotfiles/refs/heads/windows/install.ps1 -OutFile install.ps1
    .\install.ps1 -GlazeWM -Bash -Terminal

.NOTES
    Repository: https://github.com/Ruimmp/dotfiles
#>

param(
    [switch]$GlazeWM,
    [switch]$Zebar,
    [switch]$Bash,
    [switch]$Terminal,
    [switch]$Startup,
    [switch]$All
)

$ErrorActionPreference = "Stop"

#region ─── Helpers ────────────────────────────────────────────────────────────

function Write-Banner {
    Write-Host ""
    Write-Host "  ██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗" -ForegroundColor Cyan
    Write-Host "  ██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝" -ForegroundColor Cyan
    Write-Host "  ██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗" -ForegroundColor Cyan
    Write-Host "  ██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║" -ForegroundColor Cyan
    Write-Host "  ██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║" -ForegroundColor Cyan
    Write-Host "  ╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  Windows Dotfiles — https://github.com/Ruimmp/dotfiles" -ForegroundColor DarkGray
    Write-Host ""
}

function Write-Step([string]$msg)  { Write-Host "  [>>] $msg" -ForegroundColor Cyan }
function Write-Ok([string]$msg)    { Write-Host "  [OK] $msg" -ForegroundColor Green }
function Write-Warn([string]$msg)  { Write-Host "  [!!] $msg" -ForegroundColor Yellow }
function Write-Err([string]$msg)   { Write-Host "  [XX] $msg" -ForegroundColor Red }
function Write-Info([string]$msg)  { Write-Host "       $msg" -ForegroundColor DarkGray }

function Backup-IfExists([string]$path) {
    if (Test-Path $path) {
        $stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
        $dest  = "$path.backup.$stamp"
        Copy-Item -Path $path -Destination $dest -Recurse -Force
        Write-Info "Backed up to $(Split-Path $dest -Leaf)"
    }
}

#endregion

#region ─── Dependency checks ──────────────────────────────────────────────────

function Test-Command([string]$name) {
    return [bool](Get-Command $name -ErrorAction SilentlyContinue)
}

function Assert-Git {
    if (-not (Test-Command "git")) {
        Write-Err "Git is not installed. Install it with: winget install Git.Git"
        return $false
    }
    return $true
}

function Assert-GlazeWM {
    $found = (Test-Command "glazewm") -or
             (Test-Path "$env:ProgramFiles\glzr.io\GlazeWM\glazewm.exe") -or
             (Test-Path "$env:ProgramFiles\GlazeWM\glazewm.exe") -or
             (Test-Path "$env:LOCALAPPDATA\Programs\glazewm\glazewm.exe") -or
             (Test-Path "$env:USERPROFILE\.glzr\glazewm")
    if (-not $found) {
        Write-Err "GlazeWM is not installed."
        Write-Info "Install it with: winget install glzr-io.glazewm"
        return $false
    }
    return $true
}

function Assert-Zebar {
    $found = (Test-Command "zebar") -or
             (Test-Path "$env:ProgramFiles\glzr.io\Zebar\zebar.exe") -or
             (Test-Path "$env:ProgramFiles\Zebar\zebar.exe") -or
             (Test-Path "$env:LOCALAPPDATA\Programs\zebar\zebar.exe") -or
             (Test-Path "$env:USERPROFILE\.glzr\zebar")
    if (-not $found) {
        Write-Err "Zebar is not installed."
        Write-Info "Install it with: winget install glzr-io.zebar"
        return $false
    }
    if (-not (Test-Command "node")) {
        Write-Err "Node.js is required to build the Zebar widget."
        Write-Info "Install it with: winget install OpenJS.NodeJS.LTS"
        return $false
    }
    return $true
}

function Assert-OhMyPosh {
    if (-not (Test-Command "oh-my-posh")) {
        Write-Warn "oh-my-posh is not in PATH. Theme will be copied but may not load."
        Write-Info "Install it with: winget install JanDeDobbeleer.OhMyPosh"
    }
    return $true
}

#endregion

#region ─── Clone repo ─────────────────────────────────────────────────────────

function Get-Repo([string]$dest) {
    Write-Step "Cloning dotfiles repository..."
    New-Item -ItemType Directory -Path $dest -Force | Out-Null
    git clone https://github.com/Ruimmp/dotfiles.git -b windows "$dest" --depth 1 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Err "Failed to clone repository."
        return $false
    }
    Write-Ok "Repository cloned."
    return $true
}

#endregion

#region ─── Installers ─────────────────────────────────────────────────────────

function Install-GlazeWM([string]$src) {
    Write-Step "Installing GlazeWM configuration..."

    $srcFile  = Join-Path $src "glazewm\config.yaml"
    $destDir  = "$env:USERPROFILE\.glzr\glazewm"
    $destFile = Join-Path $destDir "config.yaml"

    if (-not (Test-Path $srcFile)) { Write-Err "GlazeWM config not found in repository."; return $false }

    New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    Backup-IfExists $destFile
    Copy-Item -Path $srcFile -Destination $destFile -Force
    Write-Ok "GlazeWM configuration installed."
    Write-Info "Restart GlazeWM to apply changes."
    return $true
}

function Install-Zebar([string]$src) {
    Write-Step "Installing Zebar pack (ruimmp)..."

    $srcPack   = Join-Path $src "zebar\ruimmp"
    $zebarDir  = "$env:USERPROFILE\.glzr\zebar"
    $destPack  = Join-Path $zebarDir "ruimmp"
    $settings  = Join-Path $zebarDir "settings.json"

    if (-not (Test-Path $srcPack)) { Write-Err "Zebar pack not found in repository."; return $false }

    New-Item -ItemType Directory -Path $zebarDir -Force | Out-Null
    Backup-IfExists $destPack
    Copy-Item -Path $srcPack -Destination $destPack -Recurse -Force

    Write-Step "Building Zebar widget (V1)..."
    $v1Dir = Join-Path $destPack "V1"
    Push-Location $v1Dir
    npm install --silent 2>&1 | Out-Null
    npm run build --silent 2>&1 | Out-Null
    Pop-Location

    # Update or create settings.json (Zebar v3 pack format)
    $newConfig = [PSCustomObject]@{ pack = "ruimmp"; widget = "V1"; preset = "default" }

    if (Test-Path $settings) {
        Backup-IfExists $settings
        $cfg = Get-Content $settings -Raw | ConvertFrom-Json

        $exists = $false
        foreach ($c in $cfg.startupConfigs) {
            if ($c.pack -eq "ruimmp" -and $c.widget -eq "V1") { $exists = $true; break }
        }

        if (-not $exists) {
            $cfg.startupConfigs += $newConfig
            $cfg | ConvertTo-Json -Depth 10 | Set-Content $settings -Encoding UTF8
        }
    } else {
        @{
            '$schema'      = "https://github.com/glzr-io/zebar/raw/v3.1.1/resources/settings-schema.json"
            startupConfigs = @($newConfig)
        } | ConvertTo-Json -Depth 10 | Set-Content $settings -Encoding UTF8
    }

    # Restart Zebar
    $zebarExe = $null
    if (Test-Command "zebar")                                             { $zebarExe = (Get-Command zebar).Source }
    elseif (Test-Path "$env:ProgramFiles\glzr.io\Zebar\zebar.exe")       { $zebarExe = "$env:ProgramFiles\glzr.io\Zebar\zebar.exe" }
    elseif (Test-Path "$env:LOCALAPPDATA\Programs\zebar\zebar.exe")       { $zebarExe = "$env:LOCALAPPDATA\Programs\zebar\zebar.exe" }

    if ($zebarExe) {
        Start-Process powershell -ArgumentList "-Command", "taskkill /IM zebar.exe /F 2>nul; Start-Sleep 1; & '$zebarExe'" -WindowStyle Hidden
        Write-Info "Zebar is restarting..."
    } else {
        Write-Warn "Could not find Zebar executable — restart it manually."
        Start-Process powershell -ArgumentList "-Command", "taskkill /IM zebar.exe /F 2>nul" -WindowStyle Hidden
    }

    Write-Ok "Zebar pack installed."
    return $true
}

function Install-BashDotfiles([string]$src) {
    Write-Step "Installing Bash shell configuration..."

    $srcDir = Join-Path $src "bash"
    $home   = $env:USERPROFILE

    if (-not (Test-Path $srcDir)) { Write-Err "Bash dotfiles not found in repository."; return $false }

    foreach ($file in @(".bashrc", ".bash_profile", ".inputrc")) {
        $srcFile  = Join-Path $srcDir $file
        $destFile = Join-Path $home $file
        if (Test-Path $srcFile) {
            Backup-IfExists $destFile
            Copy-Item -Path $srcFile -Destination $destFile -Force
            Write-Info "Installed ~/$file"
        }
    }

    $srcBash  = Join-Path $srcDir ".bash"
    $destBash = Join-Path $home ".bash"
    if (Test-Path $srcBash) {
        Backup-IfExists $destBash
        Copy-Item -Path $srcBash -Destination $destBash -Recurse -Force
        Write-Info "Installed ~/.bash/"
    }

    Write-Ok "Bash configuration installed."
    Write-Info "Open a new Git Bash session to apply changes."
    return $true
}

function Install-OhMyPoshTheme([string]$src) {
    Write-Step "Installing oh-my-posh theme..."

    $srcTheme  = Join-Path $src "oh-my-posh\themes\ruimmp.omp.json"
    $destDir   = "$env:USERPROFILE\.oh-my-posh\themes"
    $destTheme = Join-Path $destDir "ruimmp.omp.json"

    if (-not (Test-Path $srcTheme)) { Write-Err "oh-my-posh theme not found in repository."; return $false }

    New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    Backup-IfExists $destTheme
    Copy-Item -Path $srcTheme -Destination $destTheme -Force

    Assert-OhMyPosh | Out-Null
    Write-Ok "oh-my-posh theme installed to ~/.oh-my-posh/themes/ruimmp.omp.json"
    return $true
}

function Install-WindowsTerminal([string]$src) {
    Write-Step "Installing Windows Terminal settings..."

    $srcFile = Join-Path $src "windows-terminal\settings.json"
    $destDir = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"

    if (-not (Test-Path $srcFile)) { Write-Err "Windows Terminal settings not found in repository."; return $false }

    if (-not (Test-Path $destDir)) {
        Write-Warn "Windows Terminal does not appear to be installed."
        Write-Info "Install it from the Microsoft Store."
        return $false
    }

    $destFile = Join-Path $destDir "settings.json"
    Backup-IfExists $destFile
    Copy-Item -Path $srcFile -Destination $destFile -Force
    Write-Ok "Windows Terminal settings installed."
    Write-Info "Restart Windows Terminal to apply changes."
    return $true
}

function Install-StartupScripts([string]$src) {
    Write-Step "Installing startup scripts..."

    $srcDir  = Join-Path $src "startup"
    $destDir = "$env:USERPROFILE\.startup"

    if (-not (Test-Path $srcDir)) { Write-Err "Startup scripts not found in repository."; return $false }

    New-Item -ItemType Directory -Path $destDir -Force | Out-Null

    $copied = 0
    Get-ChildItem $srcDir -Filter "*.ps1" | ForEach-Object {
        $destFile = Join-Path $destDir $_.Name
        Backup-IfExists $destFile
        Copy-Item $_.FullName $destFile -Force
        Write-Info "Installed ~/.startup/$($_.Name)"
        $copied++
    }

    if ($copied -eq 0) { Write-Warn "No startup scripts found to install."; return $false }

    Write-Ok "Startup scripts installed to ~/.startup/"
    Write-Info "Register them manually via Task Scheduler if needed."
    return $true
}

#endregion

#region ─── Menu ───────────────────────────────────────────────────────────────

function Show-Menu {
    Write-Host "  Which components would you like to install?" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "    1) GlazeWM configuration" -ForegroundColor White
    Write-Host "    2) Zebar pack (ruimmp)" -ForegroundColor White
    Write-Host "    3) Bash shell config + oh-my-posh theme" -ForegroundColor White
    Write-Host "    4) Windows Terminal settings" -ForegroundColor White
    Write-Host "    5) Startup scripts" -ForegroundColor White
    Write-Host "    6) Everything" -ForegroundColor White
    Write-Host "    0) Exit" -ForegroundColor DarkGray
    Write-Host ""
    return (Read-Host "  Enter choice (0-6)")
}

#endregion

#region ─── Main ───────────────────────────────────────────────────────────────

function Main {
    Write-Banner

    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
    if (-not $isAdmin) {
        Write-Warn "Not running as Administrator — some operations may fail."
        Write-Host ""
    }

    # Resolve which components to install
    $doGlaze    = $GlazeWM   -or $All
    $doZebar    = $Zebar     -or $All
    $doBash     = $Bash      -or $All
    $doTerminal = $Terminal  -or $All
    $doStartup  = $Startup   -or $All

    # No parameters → show interactive menu
    $noParams = -not ($GlazeWM -or $Zebar -or $Bash -or $Terminal -or $Startup -or $All)

    if ($noParams) {
        $choice = Show-Menu

        switch ($choice) {
            "1" { $doGlaze    = $true }
            "2" { $doZebar    = $true }
            "3" { $doBash     = $true }
            "4" { $doTerminal = $true }
            "5" { $doStartup  = $true }
            "6" { $doGlaze = $doZebar = $doBash = $doTerminal = $doStartup = $true }
            "0" { Write-Info "Exiting."; return }
            default { Write-Err "Invalid choice."; return }
        }
    }

    Write-Host ""

    # Dependency checks
    if (-not (Assert-Git))                      { return }
    if ($doGlaze    -and -not (Assert-GlazeWM)) { return }
    if ($doZebar    -and -not (Assert-Zebar))   { return }

    # Clone to temp
    $tempDir = Join-Path $env:TEMP "dotfiles-$(Get-Random)"
    if (-not (Get-Repo $tempDir)) {
        Remove-Item $tempDir -Recurse -Force -ErrorAction SilentlyContinue
        return
    }

    Write-Host ""
    $ok = $true

    if ($doGlaze)    { if (-not (Install-GlazeWM          $tempDir)) { $ok = $false } }
    if ($doZebar)    { if (-not (Install-Zebar             $tempDir)) { $ok = $false } }
    if ($doBash)     {
        if (-not (Install-BashDotfiles  $tempDir)) { $ok = $false }
        if (-not (Install-OhMyPoshTheme $tempDir)) { $ok = $false }
    }
    if ($doTerminal) { if (-not (Install-WindowsTerminal   $tempDir)) { $ok = $false } }
    if ($doStartup)  { if (-not (Install-StartupScripts    $tempDir)) { $ok = $false } }

    # Cleanup
    Remove-Item $tempDir -Recurse -Force -ErrorAction SilentlyContinue

    Write-Host ""
    if ($ok) {
        Write-Ok "All done! Enjoy your setup."
    } else {
        Write-Warn "Installation finished with some errors — check the messages above."
    }
    Write-Host ""
}

Main
