Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
# Functie om Ini files te parsen
Function Parse-IniFile ($file) {
  $ini = @{}

  switch -regex -file $file {
    "^\[(.+)\]$" {
      $section = $matches[1].Trim()
      $ini[$section] = @{}
    }
    "^\s*([^#].+?)\s*=\s*(.*)" {
      $name,$value = $matches[1..2]
      # skip comments that start with semicolon:
      if (!($name.StartsWith(";"))) {
        $ini[$section][$name] = $value.Trim()
      }
    }
  }
  $ini
}

# Variabele voor het pad van onze Ini file aan te geven
$IniFilePath = "..\Variabelen.ini"
# Parsen van onze Ini file in een variabele
$IniVariabelen = Parse-IniFile $IniFilePath
# Printen van onze gegevens in de Ini file
Write-Host -ForegroundColor Yellow "Inhoud van de Ini file:"
$IniVariabelen

# Variabelen uit CSV overzetten naar aparte variabelen
$DriveLetter = $IniVariabelen.ECHO.DriveLetter
$WorkstationPath = $IniVariabelen.ECHO.WorkstationPath
$Computernaam = $Variabelen.ECHO.ServerNaam
$WorkstationNetworkName = $IniVariabelen.ECHO.WorkstationNetworkName
$ISOFilePath = $IniVariabelen.ECHO.ISOFilePath
$ISOWorkstationName = $IniVariabelen.ECHO.ISOWorkstationName
$WorkstationID = $IniVariabelen.ECHO.WorkstationID

# Mappen en shares aanmaken voor Windows 10
Write-Host -ForegroundColor Yellow "Mappen en shares aanmaken voor Windows 10."
New-Item -Path ($DriveLetter + ":\" + $WorkstationPath) -ItemType directory
New-SmbShare -Name "$WorkstationNetworkName$" -Path ($DriveLetter + ":\" + $WorkstationPath) -FullAccess Administrators
Import-Module ($DriveLetter + ":\Program Files\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1")
new-PSDrive -Name "DS002" -PSProvider "MDTProvider" -Root ($DriveLetter + ":\" + $WorkstationPath) -Description "Workstation Deployment Share" -NetworkPath "\\$Computernaam\$WorkstationNetworkName$" -Verbose | add-MDTPersistentDrive -Verbose

# Windows 10 ISO mounten
Write-Host -ForegroundColor Yellow "Windows 10 ISO mounten."
Mount-DiskImage -ImagePath ($DriveLetter + ":\" + $ISOFilePath + "\" + $ISOWorkstationName)
$volumeInfo = Get-DiskImage -DevicePath \\.\CDROM1 | Get-Volume
$ISOSourcePath = $volumeInfo.DriveLetter

# Operating System importeren in MDT
Write-Host -ForegroundColor Yellow "Operating System importeren in MDT."
import-mdtoperatingsystem -path "DS002:\Operating Systems" -SourcePath $ISOSourcePath":\" -DestinationFolder "Windows 10 Pro x64" -Verbose

# Pad aanmaken naar de LibreOffice applicatie
Write-Host -ForegroundColor Yellow "Pad aanmaken naar de LibreOffice applicatie."
new-item -path "DS002:\Applications" -enable "True" -Name "LibreOffice" -Comments "" -ItemType "folder" -Verbose

# Pad aanmaken naar de Thunderbird applicatie
Write-Host -ForegroundColor Yellow "Pad aanmaken naar de Thunderbird applicatie."
new-item -path "DS002:\Applications" -enable "True" -Name "Thunderbird" -Comments "" -ItemType "folder" -Verbose

# LibreOffice applicatie importeren in MDT
Write-Host -ForegroundColor Yellow "LibreOffice applicatie importeren in MDT."
import-MDTApplication -path "DS002:\Applications\LibreOffice" -enable "True" -Name "LibreOffice" -ShortName "LibreOffice" -Version "" -Publisher "" -Language "" -CommandLine "msi exec /i LibreOffice.msi /qb" -WorkingDirectory ".\Applications\LibreOffice" -ApplicationSourcePath ".\Apps\LibreOffice" -DestinationFolder "LibreOffice" -Verbose

# Bij error met filepath, mss absoluut pad gebruiken naar application
# import-MDTApplication -path "DS002:\Applications\LibreOffice" -enable "True" -Name "LibreOffice" -ShortName "LibreOffice" -Version "" -Publisher "" -Language "" -CommandLine "msi exec /i LibreOffice.msi /qb" -WorkingDirectory ".\Applications\LibreOffice" -ApplicationSourcePath "Z:\DeploymentServerInstallationFiles\Apps\LibreOffice" -DestinationFolder "LibreOffice" -Verbose

# Thunderbird applicatie importeren in MDT
Write-Host -ForegroundColor Yellow "Thunderbird applicatie importeren in MDT."
import-MDTApplication -path "DS002:\Applications\ThunderBird" -enable "True" -Name "ThunderBird" -ShortName "ThunderBird" -Version "" -Publisher "" -Language "" -CommandLine "msiexec /i Thunderbird.msi /qb" -WorkingDirectory ".\Applications\ThunderBird" -ApplicationSourcePath ".\Apps\Thunderbird" -DestinationFolder "ThunderBird" -Verbose

# Bij error met filepath, mss absoluut pad gebruiken naar application
# import-MDTApplication -path "DS002:\Applications\ThunderBird" -enable "True" -Name "ThunderBird" -ShortName "ThunderBird" -Version "" -Publisher "" -Language "" -CommandLine "msiexec /i Thunderbird.msi /qb" -WorkingDirectory ".\Applications\ThunderBird" -ApplicationSourcePath "Z:\DeploymentServerInstallationFiles\Apps\Thunderbird" -DestinationFolder "ThunderBird" -Verbose

# # Task Sequence importeren in MDT
# Write-Host -ForegroundColor Yellow "Task Sequence importeren in MDT."
# import-mdttasksequence -path "DS002:\Task Sequences" -Name "windows 10 workstation" -Template "Client.xml" -Comments "" -ID $WorkstationID -Version "1.0" -OperatingSystemPath "DS002:\Operating Systems\Windows 10 Pro in Windows 10 Pro x64 install.wim" -FullName "Windows 10 Workstation" -OrgName "CORONA2020" -HomePage "about:blank" -Verbose

# Nieuwe Manuel TaskSequence:
# Import-Module "C:\Program Files\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1"
# New-PSDrive -Name "DS002" -PSProvider MDTProvider -Root "C:\Workstation"
# import-mdttasksequence -path "DS002:\Task Sequences" -Name "Windows 10 Workstation" -Template "Client.xml" -Comments "" -ID "W10WS" -Version "1.0" -OperatingSystemPath "DS002:\Operating Systems\Windows 10 Pro in Windows 10 Pro x64 install.wim" -FullName "Windows User" -OrgName "CORONA2020" -HomePage "fakeupdate.net/win10ue/" -Verbose


# Files met aangepaste settings kopiëren naar juiste locatie zodat er rekening mee gehouden zal worden
Write-Host -ForegroundColor Yellow "Files met aangepaste settings kopiëren."
copy-item ".\CSVs\Workstation\Control\*" ($DriveLetter + ":\" + $WorkstationPath + "\Control") -Force -Recurse

# MDT Deployment Share Updaten
Write-Host -ForegroundColor Yellow "MDT Deployment Share Updaten."
update-MDTDeploymentShare -path "DS002:" -Verbose

# Windows Server ISO dismounten
Write-Host -ForegroundColor Yellow "Windows Server ISO dismounten."
Dismount-DiskImage -ImagePath ($DriveLetter + ":\" + $ISOFilePath + "\" + $ISOWorkstationName)

# Einde
$Shell = New-Object -ComObject "WScript.Shell"
$Button = $Shell.Popup("Klik op OK om verder te gaan.", 0, "Het script is klaar!", 0)
