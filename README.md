Start Menu Pin windows 11

Change line 59 for detection registry key on Install-StartMenu.ps1
put start2.bin in the same directory as all the files

Export the start menu on your current device by finding start.bin and start2.bin in %LocalAppData%\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState

Based off: https://www.everything365.online/2023/03/02/windows11-startmenu-layout/

Package to Intune as Install-StartMenu.ps1

Rule type: File
Path: %SystemDrive%\ProgramData\AutoPilotConfig\Start-Menu
File or folder: start.bin
Detection method: File or folder exist