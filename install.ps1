<#
.SYNOPSIS
    Installation script for Windows dotfiles.
.DESCRIPTION
    Installs GlazeWM, Zebar, Bash shell config, and oh-my-posh theme.
    Can be run directly via: irm https://raw.githubusercontent.com/Ruimmp/dotfiles/refs/heads/windows/install.ps1 | iex
.NOTES
    Repository: https://github.com/Ruimmp/dotfiles
#>

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

function Write-Step([string]$msg)    { Write-Host "  [>>] $msg" -ForegroundColor Cyan }
function Write-Ok([string]$msg)      { Write-Host "  [OK] $msg" -ForegroundColor Green }
function Write-Warn([string]$msg)    { Write-Host "  [!!] $msg" -ForegroundColor Yellow }
function Write-Err([string]$msg)     { Write-Host "  [XX] $msg" -ForegroundColor Red }
function Write-Info([string]$msg)    { Write-Host "       $msg" -ForegroundColor DarkGray }

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
        Write-Err "Node.js is required for the Zebar theme build."
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

    if (-not (Test-Path $srcFile)) {
        Write-Err "GlazeWM config not found in repository."
        return $false
    }

    New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    Backup-IfExists $destFile
    Copy-Item -Path $srcFile -Destination $destFile -Force
    Write-Ok "GlazeWM configuration installed."
    Write-Info "Restart GlazeWM to apply changes."
    return $true
}

function Install-Zebar([string]$src) {
    Write-Step "Installing Zebar theme (ruimmp-dash)..."

    $srcTheme  = Join-Path $src "zebar\ruimmp-dash"
    $zebarDir  = "$env:USERPROFILE\.glzr\zebar"
    $destTheme = Join-Path $zebarDir "ruimmp-dash"
    $settings  = Join-Path $zebarDir "settings.json"

    if (-not (Test-Path $srcTheme)) {
        Write-Err "Zebar theme not found in repository."
        return $false
    }

    New-Item -ItemType Directory -Path $zebarDir -Force | Out-Null
    Backup-IfExists $destTheme
    Copy-Item -Path $srcTheme -Destination $destTheme -Recurse -Force

    Write-Step "Building Zebar theme..."
    Push-Location $destTheme
    npm install --silent 2>&1 | Out-Null
    npm run build --silent 2>&1 | Out-Null
    Pop-Location

    # Update or create settings.json
    if (Test-Path $settings) {
        Backup-IfExists $settings
        $cfg = Get-Content $settings -Raw | ConvertFrom-Json
        $exists = $false
        foreach ($c in $cfg.startupConfigs) {
            if ($c.path -eq "ruimmp-dash/main.zebar.json") { $exists = $true; break }
        }
        if (-not $exists) {
            $cfg.startupConfigs += [PSCustomObject]@{ path = "ruimmp-dash/main.zebar.json"; preset = "default" }
            $cfg | ConvertTo-Json -Depth 10 | Set-Content $settings -Encoding UTF8
        }
    } else {
        @{
            '$schema'      = "https://github.com/glzr-io/zebar/raw/v2.7.0/resources/settings-schema.json"
            startupConfigs = @(@{ path = "ruimmp-dash/main.zebar.json"; preset = "default" })
        } | ConvertTo-Json -Depth 10 | Set-Content $settings -Encoding UTF8
    }

    # Restart Zebar
    $zebarExe = $null
    if (Test-Command "zebar") { $zebarExe = (Get-Command zebar).Source }
    elseif (Test-Path "$env:ProgramFiles\glzr.io\Zebar\zebar.exe") { $zebarExe = "$env:ProgramFiles\glzr.io\Zebar\zebar.exe" }
    elseif (Test-Path "$env:LOCALAPPDATA\Programs\zebar\zebar.exe") { $zebarExe = "$env:LOCALAPPDATA\Programs\zebar\zebar.exe" }

    if ($zebarExe) {
        Start-Process powershell -ArgumentList "-Command", "taskkill /IM zebar.exe /F 2>nul; Start-Sleep 1; & '$zebarExe'" -WindowStyle Hidden
        Write-Info "Zebar is restarting..."
    } else {
        Write-Warn "Could not find Zebar executable — restart it manually."
        Start-Process powershell -ArgumentList "-Command", "taskkill /IM zebar.exe /F 2>nul" -WindowStyle Hidden
    }

    Write-Ok "Zebar theme installed."
    return $true
}

function Install-BashDotfiles([string]$src) {
    Write-Step "Installing Bash shell configuration..."

    $srcDir  = Join-Path $src "bash"
    $home    = $env:USERPROFILE

    if (-not (Test-Path $srcDir)) {
        Write-Err "Bash dotfiles not found in repository."
        return $false
    }

    # Root config files
    foreach ($file in @(".bashrc", ".bash_profile", ".inputrc")) {
        $srcFile  = Join-Path $srcDir $file
        $destFile = Join-Path $home $file
        if (Test-Path $srcFile) {
            Backup-IfExists $destFile
            Copy-Item -Path $srcFile -Destination $destFile -Force
            Write-Info "Installed ~/$file"
        }
    }

    # .bash directory
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

    if (-not (Test-Path $srcTheme)) {
        Write-Err "oh-my-posh theme not found in repository."
        return $false
    }

    New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    Backup-IfExists $destTheme
    Copy-Item -Path $srcTheme -Destination $destTheme -Force

    Assert-OhMyPosh | Out-Null
    Write-Ok "oh-my-posh theme installed to ~/.oh-my-posh/themes/ruimmp.omp.json"
    return $true
}

#endregion

#region ─── Menu ───────────────────────────────────────────────────────────────

function Show-Menu {
    Write-Host "  Which components would you like to install?" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "    1) GlazeWM configuration" -ForegroundColor White
    Write-Host "    2) Zebar theme (ruimmp-dash)" -ForegroundColor White
    Write-Host "    3) Bash shell config + oh-my-posh theme" -ForegroundColor White
    Write-Host "    4) Everything" -ForegroundColor White
    Write-Host "    0) Exit" -ForegroundColor DarkGray
    Write-Host ""

    $choice = Read-Host "  Enter choice (0-4)"
    return $choice
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

    $choice = Show-Menu

    $doGlaze  = $choice -in @("1","4")
    $doZebar  = $choice -in @("2","4")
    $doBash   = $choice -in @("3","4")

    if ($choice -eq "0") {
        Write-Info "Exiting."
        return
    }

    if ($choice -notin @("1","2","3","4")) {
        Write-Err "Invalid choice."
        return
    }

    Write-Host ""

    # Dependency checks
    if (-not (Assert-Git)) { return }
    if ($doGlaze -and -not (Assert-GlazeWM)) { return }
    if ($doZebar -and -not (Assert-Zebar))   { return }

    # Clone to temp
    $tempDir = Join-Path $env:TEMP "dotfiles-$(Get-Random)"
    if (-not (Get-Repo $tempDir)) {
        Remove-Item $tempDir -Recurse -Force -ErrorAction SilentlyContinue
        return
    }

    Write-Host ""
    $ok = $true

    if ($doGlaze) { if (-not (Install-GlazeWM  $tempDir)) { $ok = $false } }
    if ($doZebar) { if (-not (Install-Zebar     $tempDir)) { $ok = $false } }
    if ($doBash)  {
        if (-not (Install-BashDotfiles  $tempDir)) { $ok = $false }
        if (-not (Install-OhMyPoshTheme $tempDir)) { $ok = $false }
    }

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
