# Check if the user marker file exists
$userMarkerFile = "$env:UserProfile\AppData\Local\StartMenuInstalled.txt"
if (-not (Test-Path $userMarkerFile)) {
    # Create the marker file to indicate script has run for this user
    New-Item -ItemType File -Path $userMarkerFile -Force

    If ($ENV:PROCESSOR_ARCHITEW6432 -eq "AMD64") {
        Try {
            &"$ENV:WINDIR\SysNative\WindowsPowershell\v1.0\PowerShell.exe" -File $PSCOMMANDPATH
        }
        Catch {
            Throw "Failed to start $PSCOMMANDPATH"
        }
        Exit
    }

    # Copy Start.bin file(s) to folder
    Copy-Item -Path "$env:SystemDrive\ProgramData\AutoPilotConfig\Start-Menu\*.bin" -Destination "$env:UserProfile\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\" -Force -Verbose

    # Delay
    Start-Sleep -Seconds 10

    # Restart Start Menu Experience
    Stop-Process -Name StartMenuExperienceHost -Force
}
