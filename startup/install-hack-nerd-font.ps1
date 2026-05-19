<#
.SYNOPSIS
    Ensures Hack Nerd Font is installed and registered at every logon.
.DESCRIPTION
    Copies Hack Nerd Font TTF files from C:\Fonts\HackNerdFont to the Windows
    Fonts directory and registers them in the registry.

    Why at startup, not just once: on some machines Windows silently drops
    custom font registrations after updates or profile changes. When that
    happens, terminals configured to use Hack Nerd Font fall back to the
    system default and lose all icon/glyph rendering. Running this at every
    logon guarantees the font is always registered, regardless of what Windows
    decides to do in the background.

.NOTES
    Requires administrator privileges.
    Font files must be present at C:\Fonts\HackNerdFont before running.
    Download from: https://www.nerdfonts.com/font-downloads (Hack Nerd Font)
    The Task Scheduler task is created automatically by install.ps1.
#>

$Source = "C:\Fonts\HackNerdFont"
$Dest   = "$env:WINDIR\Fonts"
$RegKey = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"

if (-not (Test-Path $Source)) { exit 0 }

Get-ChildItem $Source -Filter *.ttf | ForEach-Object {
    $FontName = $_.BaseName
    $FontFile = $_.Name
    $DestPath = Join-Path $Dest $FontFile

    if (-not (Test-Path $DestPath)) {
        Copy-Item $_.FullName $DestPath -Force
    }

    if (-not (Get-ItemProperty -Path $RegKey -Name "$FontName (TrueType)" -ErrorAction SilentlyContinue)) {
        New-ItemProperty `
            -Path $RegKey `
            -Name "$FontName (TrueType)" `
            -PropertyType String `
            -Value $FontFile `
            -Force | Out-Null
    }
}
