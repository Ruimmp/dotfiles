<#
.SYNOPSIS
    Installation script for Windows dotfiles.
.DESCRIPTION
    This script installs GlazeWM and Zebar configurations.
    Users can choose which components to install.
.NOTES
    Repository: https://github.com/Ruimmp/dotfiles
#>

# Set error action preference
$ErrorActionPreference = "Stop"

# Define colors for console output
function Write-ColorOutput($ForegroundColor) {
    $fc = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    if ($args) {
        Write-Output $args
    }
    else {
        $input | Write-Output
    }
    $host.UI.RawUI.ForegroundColor = $fc
}

function Write-Success($message) {
    Write-ColorOutput Green "[SUCCESS] $message"
}

function Write-Info($message) {
    Write-ColorOutput Cyan "[INFO] $message"
}

function Write-Warning($message) {
    Write-ColorOutput Yellow "[WARNING] $message"
}

function Write-Error($message) {
    Write-ColorOutput Red "[ERROR] $message"
}

# Print banner
function Show-Banner {
    Write-Host "`n"
    Write-ColorOutput Cyan @"
  __        ___           _                     ____        _    __ _ _
  \ \      / (_)_ __   __| | _____      _____  |  _ \  ___ | |_ / _(_) | ___  ___
   \ \ /\ / /| | '_ \ / _` |/ _ \ \ /\ / / __| | | | |/ _ \| __| |_| | |/ _ \/ __|
    \ V  V / | | | | | (_| | (_) \ V  V /\__ \ | |_| | (_) | |_|  _| | |  __/\__ \
     \_/\_/  |_|_| |_|\__,_|\___/ \_/\_/ |___/ |____/ \___/ \__|_| |_|_|\___||___/

 Windows Configuration - https://github.com/Ruimmp/dotfiles
"@
    Write-Host "`n"
}

# Check if running as administrator
function Test-Administrator {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal $user
    return $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

# Check dependencies
function Test-Dependencies {
    param (
        [Parameter(Mandatory=$true)]
        [array]$components
    )

    $missingDeps = @()
    $installInstructions = @()

    # Check for Git
    if (-Not (Get-Command git -ErrorAction SilentlyContinue)) {
        $missingDeps += "Git"
        $installInstructions += "Git: winget install Git.Git"
    }

    if ($components -contains "glazewm") {
        # Check for GlazeWM
        $glazeWMInstalled = $false

        # Check if GlazeWM is in PATH
        if (Get-Command glazewm -ErrorAction SilentlyContinue) {
            $glazeWMInstalled = $true
        }
        # Check for common installation locations
        elseif (Test-Path "$env:ProgramFiles\GlazeWM\glazewm.exe" -ErrorAction SilentlyContinue) {
            $glazeWMInstalled = $true
        }
        elseif (Test-Path "$env:ProgramFiles\glzr.io\GlazeWM\glazewm.exe" -ErrorAction SilentlyContinue) {
            $glazeWMInstalled = $true
        }
        elseif (Test-Path "$env:LOCALAPPDATA\Programs\glazewm\glazewm.exe" -ErrorAction SilentlyContinue) {
            $glazeWMInstalled = $true
        }
        # Check if the configuration directory exists (may indicate installation)
        elseif (Test-Path "$env:USERPROFILE\.glzr\glazewm" -ErrorAction SilentlyContinue) {
            $glazeWMInstalled = $true
        }

        if (-Not $glazeWMInstalled) {
            $missingDeps += "GlazeWM"
            $installInstructions += "GlazeWM: winget install glzr-io.glazewm or download from https://github.com/glzr-io/glazewm/releases"
        }
    }

    if ($components -contains "zebar") {
        # Check for Zebar
        $zebarInstalled = $false

        # Check if Zebar is in PATH
        if (Get-Command zebar -ErrorAction SilentlyContinue) {
            $zebarInstalled = $true
        }
        # Check for common installation locations
        elseif (Test-Path "$env:ProgramFiles\Zebar\zebar.exe" -ErrorAction SilentlyContinue) {
            $zebarInstalled = $true
        }
        elseif (Test-Path "$env:ProgramFiles\glzr.io\Zebar\zebar.exe" -ErrorAction SilentlyContinue) {
            $zebarInstalled = $true
        }
        elseif (Test-Path "$env:LOCALAPPDATA\Programs\zebar\zebar.exe" -ErrorAction SilentlyContinue) {
            $zebarInstalled = $true
        }
        # Check if the configuration directory exists (may indicate installation)
        elseif (Test-Path "$env:USERPROFILE\.glzr\zebar" -ErrorAction SilentlyContinue) {
            $zebarInstalled = $true
        }

        if (-Not $zebarInstalled) {
            $missingDeps += "Zebar"
            $installInstructions += "Zebar: winget install glzr-io.zebar or download from https://github.com/glzr-io/zebar/releases"
        }

        # Check for Node.js
        if (-Not (Get-Command node -ErrorAction SilentlyContinue)) {
            $missingDeps += "Node.js"
            $installInstructions += "Node.js: winget install OpenJS.NodeJS.LTS"
        }

        # Check for NPM
        if (-Not (Get-Command npm -ErrorAction SilentlyContinue)) {
            $missingDeps += "NPM"
            $installInstructions += "NPM: Included with Node.js installation"
        }
    }

    # If there are missing dependencies, print them and exit
    if ($missingDeps.Count -gt 0) {
        Write-Error "The following dependencies are missing: $($missingDeps -join ', ')"
        Write-Info "Please install them and try again:"
        foreach ($instruction in $installInstructions) {
            Write-Info $instruction
        }
        return $false
    }

    return $true
}

# Clone the repository
function Clone-Repository {
    param (
        [Parameter(Mandatory=$true)]
        [string]$tempDir
    )

    Write-Info "Creating temporary directory at $tempDir..."
    New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

    Write-Info "Cloning repository to temporary directory..."
    try {
        git clone https://github.com/Ruimmp/dotfiles.git -b windows "$tempDir" --depth 1
        Write-Success "Repository cloned successfully."
        return $true
    }
    catch {
        Write-Error "Failed to clone repository: $_"
        return $false
    }
}

# Install GlazeWM configuration
function Install-GlazeWMConfig {
    param (
        [Parameter(Mandatory=$true)]
        [string]$tempDir
    )

    $sourceConfig = Join-Path $tempDir "glazewm\config.yaml"
    $targetDir = "$env:USERPROFILE\.glzr\glazewm"
    $targetConfig = Join-Path $targetDir "config.yaml"

    # Check if the source file exists
    if (-Not (Test-Path $sourceConfig)) {
        Write-Error "GlazeWM configuration file not found in the repository."
        return $false
    }

    # Create target directory if it doesn't exist
    if (-Not (Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    }

    # Backup existing config if it exists
    if (Test-Path $targetConfig) {
        $backupPath = "$targetConfig.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
        Write-Info "Backing up existing GlazeWM configuration to $backupPath..."
        Copy-Item -Path $targetConfig -Destination $backupPath -Force
    }

    # Copy configuration file
    Write-Info "Installing GlazeWM configuration..."
    try {
        Copy-Item -Path $sourceConfig -Destination $targetConfig -Force
        Write-Success "GlazeWM configuration installed successfully."
        return $true
    }
    catch {
        Write-Error "Failed to install GlazeWM configuration: $_"
        return $false
    }
}

# Install Zebar theme
function Install-ZebarTheme {
    param (
        [Parameter(Mandatory=$true)]
        [string]$tempDir
    )

    $sourceTheme = Join-Path $tempDir "zebar\ruimmp-dash"
    $zebarDir = "$env:USERPROFILE\.glzr\zebar"
    $targetTheme = Join-Path $zebarDir "ruimmp-dash"
    $settingsFile = Join-Path $zebarDir "settings.json"

    # Check if the source theme exists
    if (-Not (Test-Path $sourceTheme)) {
        Write-Error "Zebar theme not found in the repository."
        return $false
    }

    # Create target directory if it doesn't exist
    if (-Not (Test-Path $zebarDir)) {
        New-Item -ItemType Directory -Path $zebarDir -Force | Out-Null
    }

    # Backup existing theme if it exists
    if (Test-Path $targetTheme) {
        $backupPath = "$targetTheme.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
        Write-Info "Backing up existing Zebar theme to $backupPath..."
        Copy-Item -Path $targetTheme -Destination $backupPath -Recurse -Force
    }

    # Copy theme files
    Write-Info "Installing Zebar theme..."
    try {
        Copy-Item -Path $sourceTheme -Destination $targetTheme -Recurse -Force

        # Build the theme
        Write-Info "Building Zebar theme..."
        Push-Location $targetTheme
        npm install
        npm run build
        Pop-Location

        # Update Zebar settings.json
        if (Test-Path $settingsFile) {
            Write-Info "Updating Zebar settings.json..."

            # Backup existing settings
            $backupSettings = "$settingsFile.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
            Copy-Item -Path $settingsFile -Destination $backupSettings -Force

            # Parse the settings.json file
            $settings = Get-Content -Path $settingsFile -Raw | ConvertFrom-Json

            # Check if ruimmp-dash is already in startupConfigs
            $themeExists = $false
            foreach ($config in $settings.startupConfigs) {
                if ($config.path -eq "ruimmp-dash/main.zebar.json") {
                    $themeExists = $true
                    break
                }
            }

            # Add the theme to startupConfigs if it doesn't exist
            if (-Not $themeExists) {
                if (-Not $settings.PSObject.Properties.Name -contains "startupConfigs") {
                    $settings | Add-Member -MemberType NoteProperty -Name "startupConfigs" -Value @()
                }

                $newConfig = [PSCustomObject]@{
                    path = "ruimmp-dash/main.zebar.json"
                    preset = "default"
                }

                $settings.startupConfigs += $newConfig

                # Save the updated settings.json
                $settings | ConvertTo-Json -Depth 10 | Set-Content -Path $settingsFile -Encoding UTF8
            }
        } else {
            # Create settings.json if it doesn't exist
            Write-Info "Creating Zebar settings.json..."
            $settingsContent = @{
                '$schema' = "https://github.com/glzr-io/zebar/raw/v2.7.0/resources/settings-schema.json"
                startupConfigs = @(
                    @{
                        path = "ruimmp-dash/main.zebar.json"
                        preset = "default"
                    }
                )
            }
            $settingsContent | ConvertTo-Json -Depth 10 | Set-Content -Path $settingsFile -Encoding UTF8
        }

        # Restart Zebar
        Write-Info "Restarting Zebar to apply the theme..."

        # Find Zebar executable path
        $zebarExePath = $null
        if (Get-Command zebar -ErrorAction SilentlyContinue) {
            $zebarExePath = (Get-Command zebar).Source
        }
        elseif (Test-Path "$env:ProgramFiles\glzr.io\Zebar\zebar.exe") {
            $zebarExePath = "$env:ProgramFiles\glzr.io\Zebar\zebar.exe"
        }
        elseif (Test-Path "$env:ProgramFiles\Zebar\zebar.exe") {
            $zebarExePath = "$env:ProgramFiles\Zebar\zebar.exe"
        }
        elseif (Test-Path "$env:LOCALAPPDATA\Programs\zebar\zebar.exe") {
            $zebarExePath = "$env:LOCALAPPDATA\Programs\zebar\zebar.exe"
        }

        if ($zebarExePath) {
            Start-Process powershell -ArgumentList "-Command", "taskkill /IM zebar.exe /F; Start-Sleep -Seconds 1; & '$zebarExePath'" -WindowStyle Hidden
        } else {
            Write-Warning "Could not find Zebar executable. Please restart Zebar manually to apply the theme."
            Start-Process powershell -ArgumentList "-Command", "taskkill /IM zebar.exe /F" -WindowStyle Hidden
        }

        Write-Success "Zebar theme installed and configured successfully."
        return $true
    }
    catch {
        Write-Error "Failed to install Zebar theme: $_"
        return $false
    }
}

# Cleanup temporary directory
function Remove-TempDir {
    param (
        [Parameter(Mandatory=$true)]
        [string]$tempDir
    )

    Write-Info "Cleaning up temporary directory..."
    try {
        Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
        Write-Success "Cleanup completed successfully."
    }
    catch {
        Write-Warning "Failed to clean up temporary directory: $_"
    }
}

# Main function
function Main {
    Show-Banner

    # Check if running as administrator
    if (-Not (Test-Administrator)) {
        Write-Warning "This script is not running as Administrator. Some operations might fail."
        Write-Host "Press Enter to continue or Ctrl+C to exit..." -ForegroundColor Yellow
        Read-Host
    }

    # Ask user which components to install
    $installGlazeWM = $false
    $installZebar = $false

    Write-Host "`nWhich components would you like to install?" -ForegroundColor Cyan
    Write-Host "1. GlazeWM configuration"
    Write-Host "2. Zebar theme (ruimmp-dash)"
    Write-Host "3. Both"
    Write-Host "0. Exit"

    $choice = Read-Host "`nEnter your choice (0-3)"

    switch ($choice) {
        "1" {
            $installGlazeWM = $true
            $components = @("glazewm")
        }
        "2" {
            $installZebar = $true
            $components = @("zebar")
        }
        "3" {
            $installGlazeWM = $true
            $installZebar = $true
            $components = @("glazewm", "zebar")
        }
        "0" {
            Write-Info "Exiting installation."
            return
        }
        default {
            Write-Error "Invalid choice. Exiting."
            return
        }
    }

    # Check dependencies
    if (-Not (Test-Dependencies -components $components)) {
        return
    }

    # Create temporary directory
    $tempDir = "$env:USERPROFILE\.glzr\temp"

    # Clone repository
    if (-Not (Clone-Repository -tempDir $tempDir)) {
        Remove-TempDir -tempDir $tempDir
        return
    }

    # Install selected components
    $installSuccess = $true

    if ($installGlazeWM) {
        if (-Not (Install-GlazeWMConfig -tempDir $tempDir)) {
            $installSuccess = $false
        }
    }

    if ($installZebar) {
        if (-Not (Install-ZebarTheme -tempDir $tempDir)) {
            $installSuccess = $false
        }
    }

    # Cleanup
    Remove-TempDir -tempDir $tempDir

    # Final message
    if ($installSuccess) {
        Write-Host "`n"
        Write-Success "Installation completed successfully!"
        if ($installGlazeWM) {
            Write-Info "GlazeWM configuration has been installed. Restart GlazeWM to apply changes."
        }
        if ($installZebar) {
            Write-Info "Zebar theme has been installed and Zebar has been restarted."
        }
        Write-Host "`nThank you for using these dotfiles!" -ForegroundColor Cyan
    } else {
        Write-Host "`n"
        Write-Warning "Installation completed with some errors. Please check the messages above."
    }
}

# Run the main function
Main
