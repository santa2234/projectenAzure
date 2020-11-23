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
$Computernaam = $IniVariabelen.ECHO.ServerNaam
$WDSPath = $IniVariabelen.ECHO.WDSPath

# WDS downloaden
Write-Host -ForegroundColor Yellow "WDS downloaden."
Install-WindowsFeature wds-deployment -includemanagementtools

# Server initialiseren voor WDS
Write-Host -ForegroundColor Yellow "Server initialiseren voor WDS."
$remInstallLocation = $DriveLetter + ":\" + $WDSPath
wdsutil /Verbose /Progress /Initialize-Server /Server:$Computernaam /remInst:$remInstallLocation

# Instellen van server om op alle DHCP requests voor PXE Booten te antwoorden
Write-Host -ForegroundColor Yellow "Instellen van server om op alle DHCP requests voor PXE Booten te antwoorden."
wdsutil /Set-Server /AnswerClients:All

# Installeren van WSUS
Write-Host -ForegroundColor Yellow "Installeren van WSUS."
Install-WindowsFeature -Name UpdateServices, UpdateServices-WidDB, UpdateServices-Services, UpdateServices-RSAT, UpdateServices-API, UpdateServices-UI

# Einde
$Shell = New-Object -ComObject "WScript.Shell"
$Button = $Shell.Popup("Klik op OK om verder te gaan.", 0, "Het script is klaar!", 0)
