Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
# Instellen van het pad naar de MDT installer
$MDTSetupFile = "MDT\MicrosoftDeploymentToolkit_x64.msi"

# MDT installeren
Write-Host -ForegroundColor Yellow "MDT installeren."
msiexec /i $MDTSetupFile /qb

# Instellen van het pad naar de ADK en PE installers
$ADKSetupFile = ".\MDT\ADK\adksetup.exe"
$WinPEAddonSetupFile = ".\MDT\PE\adkwinpesetup.exe"

# Validatie in commentaar, want anders gaan we het overal moeten aanpassen? :p
# # Validation
# if (!(Test-Path -path $ADKSetupFile)) {Write-Warning "Could not find Windows 10 ADK Setup files, aborting...";Break}
# if (!(Test-Path -path $WinPEAddonSetupFile)) {Write-Warning "Could not find WinPE Addon Setup files, aborting...";Break}

# Install Windows ADK 10 with components for MDT and/or ConfigMgr
# Om te troubleshooten check de logs in %temp%\adk
$SetupName = "Windows ADK 10"
$SetupSwitches = "/Features OptionId.DeploymentTools OptionId.ImagingAndConfigurationDesigner OptionId.ICDConfigurationDesigner OptionId.UserStateMigrationTool /norestart /quiet /ceip off"
Write-Output "Starting install of $SetupName"
Write-Output "Command line to start is: $ADKSetupFile $SetupSwitches"
Start-Process -FilePath $ADKSetupFile -ArgumentList $SetupSwitches -NoNewWindow -Wait
Write-Output "Finished installing $SetupName"

# Install WinPE Addon for Windows ADK 10
# Om te troubleshooten check de logs in %temp%\adk
$SetupName = "WinPE Addon for Windows ADK 10"
$SetupSwitches = "/Features OptionId.WindowsPreinstallationEnvironment /norestart /quiet /ceip off"
Write-Output "Starting install of $SetupName"
Write-Output "Command line to start is: $WinPEAddonSetupFile $SetupSwitches"
Start-Process -FilePath $WinPEAddonSetupFile -ArgumentList $SetupSwitches -NoNewWindow -Wait
Write-Output "Finished installing $SetupName"

# Einde
$Shell = New-Object -ComObject "WScript.Shell"
$Button = $Shell.Popup("Klik op OK om verder te gaan.", 0, "Het script is klaar!", 0)
