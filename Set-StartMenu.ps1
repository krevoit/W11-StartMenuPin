<#
.SYNOPSIS
This script configures the Start Menu for a user and ensures it applies only once per user.
.DESCRIPTION
The script works by performing the following steps:
1. Copies the `start2.bin` file to the appropriate user directory.
2. Restarts Explorer to apply the changes.
3. Creates a registry key to indicate that the Start Menu has been configured for the user.
#>

$RegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StartMenu"
$RegistryValueStartMenuConfigured = "StartMenuConfigured"
$BinFilePath = "$env:SystemDrive\ProgramData\AutoPilotConfig\StartMenu\start2.bin"
$UserProfilePath = "$env:UserProfile\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState"

# Function to configure the Start Menu
function Configure-StartMenu {
    param(
        [string]$binFilePath = $BinFilePath,
        [string]$userProfilePath = $UserProfilePath
    )

    try {
        # Ensure the Start Menu binary configuration file exists
        if (Test-Path -Path $binFilePath) {
            # Copy the Start Menu binary configuration file
            Copy-Item -Path $binFilePath -Destination $userProfilePath -Force

            Write-Host "Start Menu configured successfully."
        } else {
            Write-Host "Start Menu binary configuration file not found: $binFilePath" -ForegroundColor Red
        }
    }
    catch {
        $ErrorMessage = "An error occurred while configuring the Start Menu: $($_.Exception.Message)"
        Write-Host $ErrorMessage -ForegroundColor Red
    }
}

# Function to restart Explorer
function Restart-Explorer {
    try {
        taskkill /f /im explorer.exe
        Start-Process explorer.exe
        Write-Host "Explorer.exe restarted successfully."
    }
    catch {
        $ErrorMessage = "Failed to restart explorer.exe. Error: $($_.Exception.Message)"
        Write-Host $ErrorMessage
    }
}

# Check if the registry value indicating Start Menu configuration has been made
$startMenuConfigured = Get-ItemProperty -Path $RegistryPath -Name $RegistryValueStartMenuConfigured -ErrorAction SilentlyContinue

if ($startMenuConfigured -eq $null) {
    # The registry value indicating Start Menu configuration has not been set, so run configuration
    Write-Host "Configuring Start Menu"
    Configure-StartMenu
    Set-ItemProperty -Path $RegistryPath -Name $RegistryValueStartMenuConfigured -Value "true" -Force
    Restart-Explorer
    Write-Host "Start Menu configuration completed."
} else {
    Write-Host "The Start Menu has already been configured. Nothing to do."
}
