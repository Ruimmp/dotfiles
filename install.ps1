<#
.SYNOPSIS
    Installation script for Windows dotfiles.
.DESCRIPTION
    Installs GlazeWM config, Zebar pack, Bash shell config, oh-my-posh theme,
    Windows Terminal settings, and startup scripts via an interactive menu.
.EXAMPLE
    # Run directly — also works via: irm https://raw.githubusercontent.com/Ruimmp/dotfiles/refs/heads/windows/install.ps1 | iex
    .\install.ps1
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

function Test-GlazeWM {
    return (Test-Command "glazewm") -or
           (Test-Path "$env:ProgramFiles\glzr.io\GlazeWM\glazewm.exe") -or
           (Test-Path "$env:ProgramFiles\GlazeWM\glazewm.exe") -or
           (Test-Path "$env:LOCALAPPDATA\Programs\glazewm\glazewm.exe") -or
           (Test-Path "$env:USERPROFILE\.glzr\glazewm")
}

function Test-Zebar {
    return (Test-Command "zebar") -or
           (Test-Path "$env:ProgramFiles\glzr.io\Zebar\zebar.exe") -or
           (Test-Path "$env:ProgramFiles\Zebar\zebar.exe") -or
           (Test-Path "$env:LOCALAPPDATA\Programs\zebar\zebar.exe") -or
           (Test-Path "$env:USERPROFILE\.glzr\zebar")
}

function Test-Nvm {
    return (Test-Command "nvm") -or
           (Test-Path "$env:ProgramFiles\nvm\nvm.exe") -or
           (Test-Path "$env:APPDATA\nvm\nvm.exe")
}

function Show-RequirementsCheck([bool]$NeedGlaze, [bool]$NeedZebar, [bool]$NeedBash, [bool]$NeedTerminal, [bool]$NeedStartup) {
    # Build requirement list for selected components
    $reqs = [System.Collections.Generic.List[hashtable]]::new()

    if ($NeedGlaze) {
        $reqs.Add(@{ Label = "GlazeWM";                      OK = (Test-GlazeWM);                WingetId = "glzr-io.glazewm";            Required = $true  })
    }
    if ($NeedZebar) {
        $reqs.Add(@{ Label = "Zebar";                        OK = (Test-Zebar);                  WingetId = "glzr-io.zebar";              Required = $true  })
        $hasNode  = Test-Command "node"
        $hasNvm   = Test-Nvm
        $nodeOk   = $hasNode -or $hasNvm
        $nodeLabel   = if ($hasNvm -and -not $hasNode) { "Node.js (NVM detected — version selected at install)" } else { "Node.js (to build widget)" }
        $nodeWinget  = if (-not $nodeOk) { "OpenJS.NodeJS.LTS" } else { $null }
        $reqs.Add(@{ Label = $nodeLabel; OK = $nodeOk; WingetId = $nodeWinget; Required = $true })
    }
    if ($NeedBash) {
        $gitBash = (Test-Command "bash") -or (Test-Path "C:\Program Files\Git\bin\bash.exe")
        $reqs.Add(@{ Label = "Git for Windows / Git Bash";   OK = $gitBash;                      WingetId = "Git.Git";                    Required = $true  })
        $reqs.Add(@{ Label = "oh-my-posh (prompt theme)";    OK = (Test-Command "oh-my-posh");   WingetId = "JanDeDobbeleer.OhMyPosh";   Required = $false })
    }
    if ($NeedTerminal) {
        $wtPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
        $reqs.Add(@{ Label = "Windows Terminal";             OK = (Test-Path $wtPath);           WingetId = "Microsoft.WindowsTerminal";  Required = $true  })
    }
    if ($NeedStartup) {
        $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
        $reqs.Add(@{ Label = "Administrator privileges";     OK = $isAdmin;                      WingetId = $null;                        Required = $false })
    }

    # Display
    Write-Host "  Requirements for selected components:" -ForegroundColor Cyan
    Write-Host ""

    $missingRequired = [System.Collections.Generic.List[string]]::new()
    $missingOptional = [System.Collections.Generic.List[string]]::new()

    foreach ($r in $reqs) {
        if ($r.OK) {
            Write-Host "  [OK] $($r.Label)" -ForegroundColor Green
        } elseif ($r.Required) {
            Write-Host "  [!!] $($r.Label) — not found" -ForegroundColor Yellow
            if ($r.WingetId) { $missingRequired.Add($r.WingetId) }
        } else {
            Write-Host "   [~] $($r.Label) — not found (optional)" -ForegroundColor DarkGray
            if ($r.WingetId) { $missingOptional.Add($r.WingetId) }
        }
    }

    Write-Host ""

    if ($missingRequired.Count -gt 0) {
        Write-Host "  Missing required dependencies. Install with:" -ForegroundColor Yellow
        $nodeWinget = "OpenJS.NodeJS.LTS"
        if ($missingRequired -contains $nodeWinget) {
            $otherPkgs = $missingRequired | Where-Object { $_ -ne $nodeWinget }
            if ($otherPkgs.Count -gt 0) {
                Write-Host "  winget install $($otherPkgs -join ' ')" -ForegroundColor White
            }
            Write-Host "  Node.js (pick one):" -ForegroundColor DarkGray
            Write-Host "    winget install OpenJS.NodeJS.LTS          # direct install" -ForegroundColor White
            Write-Host "    winget install CoreyButler.NVMforWindows  # version manager" -ForegroundColor White
        } else {
            Write-Host "  winget install $($missingRequired -join ' ')" -ForegroundColor White
        }
        Write-Host ""
    }
    if ($missingOptional.Count -gt 0) {
        Write-Host "  Optional (recommended):" -ForegroundColor DarkGray
        Write-Host "  winget install $($missingOptional -join ' ')" -ForegroundColor DarkGray
        Write-Host ""
    }

    $prompt = if ($missingRequired.Count -gt 0) {
        "  Some dependencies are missing. Continue anyway? [y/N] "
    } else {
        "  Everything looks good. Proceed with installation? [Y/n] "
    }

    Write-Host $prompt -NoNewline -ForegroundColor Cyan
    $ans = Read-Host

    if ($missingRequired.Count -gt 0) {
        return ($ans -eq 'y' -or $ans -eq 'Y')
    } else {
        return ($ans -ne 'n' -and $ans -ne 'N')
    }
}

#endregion

#region ─── Clone repo ─────────────────────────────────────────────────────────

function Get-Repo([string]$dest) {
    Write-Step "Cloning dotfiles repository..."
    New-Item -ItemType Directory -Path $dest -Force | Out-Null
    git clone https://github.com/Ruimmp/dotfiles.git -b windows "$dest" --depth 1 --quiet | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Err "Failed to clone repository."
        return $false
    }
    Write-Ok "Repository cloned."
    return $true
}

#endregion

#region ─── Installers ─────────────────────────────────────────────────────────

function Install-WingetPackage([string]$id, [string]$displayName) {
    Write-Step "Installing $displayName via winget..."
    winget install --id $id --silent --accept-package-agreements --accept-source-agreements
    if ($LASTEXITCODE -ne 0) {
        Write-Warn "winget install failed for $displayName."
        return $false
    }
    Write-Ok "$displayName installed."
    return $true
}

function Install-GlazeWM([string]$src) {
    Write-Step "Installing GlazeWM configuration..."

    if (-not (Test-GlazeWM)) {
        if (-not (Install-WingetPackage "glzr-io.glazewm" "GlazeWM")) {
            Write-Warn "GlazeWM installation failed — config will still be copied."
        }
    }

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

function Invoke-EnsureNode {
    if (Test-Command "node") { return $true }

    if (-not (Test-Nvm)) {
        Write-Err "Node.js is required to build the Zebar widget but was not found."
        Write-Info "Install directly:   winget install OpenJS.NodeJS.LTS"
        Write-Info "Or via NVM:         winget install CoreyButler.NVMforWindows"
        return $false
    }

    Write-Host ""
    Write-Host "  NVM detected — no Node.js version is currently active." -ForegroundColor Cyan
    Write-Host "  [1] Install LTS  (recommended)" -ForegroundColor White
    Write-Host "  [2] Install a specific version" -ForegroundColor White
    Write-Host ""
    Write-Host "  Choice [1]: " -NoNewline -ForegroundColor Cyan
    $choice = Read-Host

    if ($choice -eq '2') {
        Write-Host "  Version number (e.g. 22, 20.18.0): " -NoNewline -ForegroundColor Cyan
        $version = Read-Host
        if (-not $version) { $version = "lts" }
    } else {
        $version = "lts"
    }

    Write-Step "Installing Node.js $version via NVM..."
    nvm install $version
    if ($LASTEXITCODE -ne 0) { Write-Err "nvm install $version failed."; return $false }

    nvm use $version
    if ($LASTEXITCODE -ne 0) { Write-Err "nvm use $version failed."; return $false }

    if (Test-Command "node") {
        Write-Ok "Node.js $(node --version) is now active."
        return $true
    }

    Write-Warn "NVM installed the version but 'node' is not yet in PATH."
    Write-Info "Restart your terminal after this script finishes, then re-run if the build failed."
    return $false
}

function Install-Zebar([string]$src) {
    Write-Step "Installing Zebar pack (ruimmp)..."

    if (-not (Test-Zebar)) {
        if (-not (Install-WingetPackage "glzr-io.zebar" "Zebar")) {
            Write-Warn "Zebar installation failed — pack will still be copied."
        }
    }

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

    if (-not (Test-Path $v1Dir)) {
        Write-Err "V1 widget directory not found at $v1Dir"
        return $false
    }

    if (-not (Invoke-EnsureNode)) { return $false }

    Push-Location $v1Dir
    npm install --silent | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Pop-Location
        Write-Err "npm install failed — check that Node.js is installed correctly."
        return $false
    }
    npm run build --silent | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Pop-Location
        Write-Err "Widget build failed."
        return $false
    }
    Pop-Location

    $distDir = Join-Path $v1Dir "dist"
    if (-not (Test-Path $distDir)) {
        Write-Err "Build output not found — dist/ folder is missing after build."
        return $false
    }
    Write-Ok "Widget built successfully."

    # Write settings.json — set ruimmp as the sole startup config (Zebar v3 pack format)
    $newConfig = [PSCustomObject]@{ pack = "ruimmp"; widget = "V1"; preset = "default" }

    if (Test-Path $settings) {
        Backup-IfExists $settings
        $cfg = Get-Content $settings -Raw | ConvertFrom-Json
        $cfg.startupConfigs = @($newConfig)
        $cfg | ConvertTo-Json -Depth 10 | Set-Content $settings -Encoding UTF8
    } else {
        [ordered]@{
            '$schema'      = "https://github.com/glzr-io/zebar/raw/v3.1.1/resources/settings-schema.json"
            startupConfigs = @($newConfig)
        } | ConvertTo-Json -Depth 10 | Set-Content $settings -Encoding UTF8
    }

    Write-Ok "Zebar pack installed."
    return $true
}

function Install-BashDotfiles([string]$src) {
    Write-Step "Installing Bash shell configuration..."

    $srcDir  = Join-Path $src "bash"
    $destHome = $env:USERPROFILE

    if (-not (Test-Path $srcDir)) { Write-Err "Bash dotfiles not found in repository."; return $false }

    foreach ($file in @(".bashrc", ".bash_profile", ".inputrc")) {
        $srcFile  = Join-Path $srcDir $file
        $destFile = Join-Path $destHome $file
        if (Test-Path $srcFile) {
            Backup-IfExists $destFile
            Copy-Item -Path $srcFile -Destination $destFile -Force
            Write-Info "Installed ~/$file"
        }
    }

    $srcBash  = Join-Path $srcDir ".bash"
    $destBash = Join-Path $destHome ".bash"
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

    $srcFile  = Join-Path $src "startup\install-hack-nerd-font.ps1"
    $destDir  = "$env:USERPROFILE\.startup"
    $destFile = Join-Path $destDir "install-hack-nerd-font.ps1"

    if (-not (Test-Path $srcFile)) { Write-Err "Startup script not found in repository."; return $false }

    New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    Backup-IfExists $destFile
    Copy-Item $srcFile $destFile -Force
    Write-Info "Installed ~/.startup/install-hack-nerd-font.ps1"

    # Register a Task Scheduler task to run the font check at every logon
    Write-Step "Registering Task Scheduler task..."
    try {
        $action    = New-ScheduledTaskAction `
                        -Execute   "powershell.exe" `
                        -Argument  "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$destFile`""
        $trigger   = New-ScheduledTaskTrigger -AtLogOn
        $settings  = New-ScheduledTaskSettingsSet `
                        -AllowStartIfOnBatteries `
                        -DontStopIfGoingOnBatteries `
                        -Hidden
        $principal = New-ScheduledTaskPrincipal `
                        -UserId   $env:USERNAME `
                        -RunLevel Highest `
                        -LogonType Interactive
        Register-ScheduledTask `
            -TaskName "Hack Nerd Font - Startup Check" `
            -Action    $action `
            -Trigger   $trigger `
            -Settings  $settings `
            -Principal $principal `
            -Force | Out-Null
        Write-Ok "Task registered — font check will run at every logon (admin)."
    } catch {
        Write-Warn "Could not register Task Scheduler task: $_"
        Write-Info "Register it manually: run at logon, highest privileges,"
        Write-Info "pointing to $destFile"
    }

    Write-Ok "Startup scripts installed."
    return $true
}

#endregion

#region ─── Menu ───────────────────────────────────────────────────────────────

function Show-InteractiveMenu {
    $items = @(
        "GlazeWM configuration"
        "Zebar pack (ruimmp)"
        "Bash shell config + oh-my-posh theme"
        "Windows Terminal settings"
        "Startup scripts"
    )
    $checked = @($false, $false, $false, $false, $false)
    $idx     = 0
    $width   = [Console]::WindowWidth

    [Console]::CursorVisible = $false
    $top = [Console]::CursorTop

    # Reserve space so redraws don't scroll the buffer
    $totalLines = $items.Count + 4   # hint + blank + items + blank + prompt
    1..$totalLines | ForEach-Object { Write-Host "" }

    $draw = {
        [Console]::SetCursorPosition(0, $top)

        $hint = "  " + [char]8593 + [char]8595 + " navigate   Space toggle   A select all   Enter install   Esc exit"
        Write-Host $hint.PadRight($width - 1) -ForegroundColor DarkGray
        Write-Host "".PadRight($width - 1)

        for ($i = 0; $i -lt $items.Count; $i++) {
            $isFocused  = ($i -eq $idx)
            $isChecked  = $checked[$i]
            $arrow      = if ($isFocused) { ">" } else { " " }
            $box        = if ($isChecked)  { "[x]" } else { "[ ]" }
            $arrowColor = if ($isFocused) { "Cyan"  } else { "DarkGray" }
            $boxColor   = if ($isChecked)  { "Green" } else { "DarkGray" }
            $textColor  = if ($isFocused -or $isChecked) { "White" } else { "Gray" }

            Write-Host "  " -NoNewline
            Write-Host $arrow -NoNewline -ForegroundColor $arrowColor
            Write-Host "  $box " -NoNewline -ForegroundColor $boxColor
            Write-Host $items[$i].PadRight($width - 9) -ForegroundColor $textColor
        }

        Write-Host "".PadRight($width - 1)

        $selected = ($checked | Where-Object { $_ }).Count
        $summary  = if ($selected -eq 0) { "  Nothing selected" } else { "  $selected component(s) selected" }
        Write-Host $summary.PadRight($width - 1) -ForegroundColor $(if ($selected -gt 0) { "Cyan" } else { "DarkGray" })
    }

    try {
        $done = $false
        while (-not $done) {
            & $draw
            $key = [Console]::ReadKey($true)

            switch ($key.Key) {
                ([ConsoleKey]::UpArrow)   { if ($idx -gt 0) { $idx-- } }
                ([ConsoleKey]::DownArrow) { if ($idx -lt ($items.Count - 1)) { $idx++ } }
                ([ConsoleKey]::Spacebar)  { $checked[$idx] = -not $checked[$idx] }
                ([ConsoleKey]::A) {
                    $allOn = ($checked -notcontains $false)
                    for ($i = 0; $i -lt $checked.Count; $i++) { $checked[$i] = -not $allOn }
                }
                ([ConsoleKey]::Enter)  { $done = $true }
                ([ConsoleKey]::Escape) {
                    for ($i = 0; $i -lt $checked.Count; $i++) { $checked[$i] = $false }
                    $done = $true
                }
            }
        }
    } finally {
        [Console]::CursorVisible = $true
        Write-Host ""
    }

    return $checked
}

#endregion

#region ─── Main ───────────────────────────────────────────────────────────────

function Main {
    Write-Banner

    # Execution policy check
    $currentPolicy = Get-ExecutionPolicy -Scope CurrentUser
    if ($currentPolicy -eq 'Undefined') { $currentPolicy = Get-ExecutionPolicy }
    if ($currentPolicy -in @('Restricted', 'AllSigned')) {
        Write-Warn "Execution policy is '$currentPolicy' — running .ps1 files directly is blocked."
        Write-Info "Fix with:  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser"
        Write-Host ""
    }

    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
    if (-not $isAdmin) {
        Write-Warn "Not running as Administrator — some operations may fail."
        Write-Host ""
    }

    # Git is always required to clone the repository
    if (-not (Test-Command "git")) {
        Write-Err "Git is required to clone the repository but was not found."
        Write-Info "Install it with:  winget install Git.Git"
        Write-Host ""
        return
    }

    $choices = Show-InteractiveMenu

    if ($choices -notcontains $true) {
        Write-Info "Nothing selected. Exiting."
        return
    }

    $doGlaze    = $choices[0]
    $doZebar    = $choices[1]
    $doBash     = $choices[2]
    $doTerminal = $choices[3]
    $doStartup  = $choices[4]

    # Requirements check — shows what's needed, asks for confirmation
    if (-not (Show-RequirementsCheck $doGlaze $doZebar $doBash $doTerminal $doStartup)) {
        Write-Info "Cancelled."
        return
    }

    Write-Host ""

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

    # Launch prompts
    if ($doGlaze -or $doZebar) {
        Write-Host ""

        if ($doGlaze -and (Test-GlazeWM)) {
            Write-Host "  Launch GlazeWM now? [Y/n] " -NoNewline -ForegroundColor Cyan
            $ans = Read-Host
            if ($ans -ne 'n' -and $ans -ne 'N') {
                $glazeExe = $null
                if (Test-Command "glazewm")                                                  { $glazeExe = (Get-Command glazewm).Source }
                elseif (Test-Path "$env:ProgramFiles\glzr.io\GlazeWM\glazewm.exe")          { $glazeExe = "$env:ProgramFiles\glzr.io\GlazeWM\glazewm.exe" }
                elseif (Test-Path "$env:LOCALAPPDATA\Programs\glazewm\glazewm.exe")         { $glazeExe = "$env:LOCALAPPDATA\Programs\glazewm\glazewm.exe" }
                if ($glazeExe) { Start-Process $glazeExe; Write-Ok "GlazeWM started." }
                else            { Write-Warn "Could not find GlazeWM executable — start it manually." }
            }
        }

        if ($doZebar -and (Test-Zebar)) {
            Write-Host "  Launch Zebar now? [Y/n] " -NoNewline -ForegroundColor Cyan
            $ans = Read-Host
            if ($ans -ne 'n' -and $ans -ne 'N') {
                $zebarExe = $null
                if (Test-Command "zebar")                                              { $zebarExe = (Get-Command zebar).Source }
                elseif (Test-Path "$env:ProgramFiles\glzr.io\Zebar\zebar.exe")        { $zebarExe = "$env:ProgramFiles\glzr.io\Zebar\zebar.exe" }
                elseif (Test-Path "$env:LOCALAPPDATA\Programs\zebar\zebar.exe")       { $zebarExe = "$env:LOCALAPPDATA\Programs\zebar\zebar.exe" }
                if ($zebarExe) {
                    Start-Process powershell -ArgumentList "-Command", "taskkill /IM zebar.exe /F 2>nul; Start-Sleep 1; & '$zebarExe'" -WindowStyle Hidden
                    Write-Ok "Zebar started."
                } else {
                    Write-Warn "Could not find Zebar executable — start it manually."
                }
            }
        }
    }

    Write-Host ""
}

Main
