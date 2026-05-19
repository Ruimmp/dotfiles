<#
.SYNOPSIS
    Installs Hack Nerd Font from a local Fonts directory.
.DESCRIPTION
    Copies Hack Nerd Font TTF files from C:\Fonts\HackNerdFont to the Windows Fonts
    directory and registers them in the registry so all applications can use them.
.NOTES
    Requires administrator privileges.
    Font files must be present at C:\Fonts\HackNerdFont before running.
    Download from: https://www.nerdfonts.com/font-downloads (Hack Nerd Font)
#>

$Source = "C:\Fonts\HackNerdFont"
$Dest   = "$env:WINDIR\Fonts"
$RegKey = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"

Get-ChildItem $Source -Filter *.ttf | ForEach-Object {
    $FontName = $_.BaseName
    $FontFile = $_.Name
    $DestPath = Join-Path $Dest $FontFile

    if (-not (Test-Path $DestPath)) {
        Copy-Item $_.FullName $DestPath -Force
    }

    if (-not (Get-ItemProperty -Path $RegKey -Name $FontName -ErrorAction SilentlyContinue)) {
        New-ItemProperty `
            -Path $RegKey `
            -Name "$FontName (TrueType)" `
            -PropertyType String `
            -Value $FontFile `
            -Force | Out-Null
    }
}
