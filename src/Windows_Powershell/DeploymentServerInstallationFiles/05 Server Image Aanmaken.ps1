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
$ServerPath = $IniVariabelen.ECHO.ServerPath
$Computernaam = $IniVariabelen.ECHO.ServerNaam
$ServerNetworkName = $IniVariabelen.ECHO.ServerNetworkName
$ISOFilePath = $IniVariabelen.ECHO.ISOFilePath
$ISOServerName = $IniVariabelen.ECHO.ISOServerName
$ServerID = $IniVariabelen.ECHO.ServerID

# Mappen en shares aanmaken voor Windows Server
Write-Host -ForegroundColor Yellow "Mappen en shares aanmaken voor Windows Server."
New-Item -Path ($DriveLetter + ":\" + $ServerPath) -ItemType directory
New-SmbShare -Name "$ServerNetworkName$" -Path ($DriveLetter + ":\" + $ServerPath) -FullAccess Administrators
Import-Module ($DriveLetter + ":\Program Files\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1")
new-PSDrive -Name "DS001" -PSProvider "MDTProvider" -Root ($DriveLetter + ":\" + $ServerPath) -Description "Server Deployment Share" -NetworkPath "\\$Computernaam\$ServerNetworkName$" -Verbose | add-MDTPersistentDrive -Verbose

# Windows Server ISO mounten
Write-Host -ForegroundColor Yellow "Windows Server ISO mounten."
Mount-DiskImage -ImagePath ($DriveLetter + ":\" + $ISOFilePath + "\" + $ISOServerName)
$volumeInfo = Get-DiskImage -DevicePath \\.\CDROM1 | Get-Volume
$ISOSourcePath = $volumeInfo.DriveLetter

# Operating System importeren in MDT
Write-Host -ForegroundColor Yellow "Operating System importeren in MDT."
import-mdtoperatingsystem -path "DS001:\Operating Systems" -SourcePath $ISOSourcePath":\" -DestinationFolder "Windows Server 2019 SERVERSTANDARDCORE x64" -Verbose

# # Task Sequence importeren in MDT
# Write-Host -ForegroundColor Yellow "Task Sequence importeren in MDT."
# import-mdttasksequence -path "DS001:\Task Sequences" -Name "Windows Server 2019" -Template "Server.xml" -Comments "The tasksequence for deploying windows server 2019." -ID $ServerID -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Windows Server 2019 SERVERSTANDARD in Windows Server 2019 SERVERSTANDARDCORE x64 install.wim" -FullName "Windows server 2019" -OrgName "CORONA2020" -HomePage "about:blank" -Verbose

# Files met aangepaste settings kopi�ren naar juiste locatie zodat er rekening mee gehouden zal worden
Write-Host -ForegroundColor Yellow "Files met aangepaste settings kopi�ren."
copy-item ".\CSVs\Server\Control\*" ($DriveLetter + ":\" + $ServerPath + "\Control") -Force -Recurse

# MDT Deployment Share Updaten
Write-Host -ForegroundColor Yellow "MDT Deployment Share Updaten."
update-MDTDeploymentShare -path "DS001:" -Verbose

# Windows Server ISO dismounten
Write-Host -ForegroundColor Yellow "Windows Server ISO dismounten."
Dismount-DiskImage -ImagePath ($DriveLetter + ":\" + $ISOFilePath + "\" + $ISOServerName)

# Einde
$Shell = New-Object -ComObject "WScript.Shell"
$Button = $Shell.Popup("Klik op OK om verder te gaan.", 0, "Het script is klaar!", 0)
