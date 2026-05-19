<#
.SYNOPSIS
    Keeps Raycast running in the background.
.DESCRIPTION
    Polls every 15 seconds and restarts Raycast if the process is not found.
    Intended to run at system startup via Task Scheduler.
.NOTES
    Raycast must be installed at the default location:
    %LOCALAPPDATA%\Programs\Raycast\Raycast.exe
#>

while ($true) {
    $raycast = Get-Process "Raycast" -ErrorAction SilentlyContinue

    if (-not $raycast) {
        Start-Process "$env:LOCALAPPDATA\Programs\Raycast\Raycast.exe" -WindowStyle Hidden
    }

    Start-Sleep -Seconds 15
}
