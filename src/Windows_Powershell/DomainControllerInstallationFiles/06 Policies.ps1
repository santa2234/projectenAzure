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

$POLFilePath = '.\Policies POL Files\'

$ServerNaam = $IniVariabelen.ALFA.ServerNaam
$DomeinNaam = $IniVariabelen.ALGEMEEN.DomeinNaam

# Policies maken
Write-Host -ForegroundColor Yellow "Policies aanmaken."

# Control Panel Policies
New-GPO `
-Name "Control Panel Access Granted" `
-Comment "This GPO grants access to the Control Panel." | New-GPLink `
-Target "OU=IT Administratie,OU=CoronaAfdeling,DC=CORONA2020,DC=local" `
-LinkEnabled Yes
$GPOID = (Get-GPO -Name "Control Panel Access Granted").Id.ToString()
Copy-Item -Path $POLFilePath"Control Panel Access Granted\*" -Destination "\\alfa\SYSVOL\CORONA2020.local\Policies\{$GPOID}" -Recurse -Force
$RegistryPolPath = "\\$ServerNaam\SYSVOL\$DomeinNaam\Policies\{$GPOID}\User"
Get-ChildItem -Path $RegistryPolPath
$RegPolPath = Join-Path -Path $RegistryPolPath -ChildPath 'Registry.pol'
Parse-PolFile -Path $RegPolPath

New-GPO `
-Name "Control Panel Access Denied" `
-Comment "This GPO prohibits access to the Control Panel." | New-GPLink `
-Target "OU=CoronaAfdeling,DC=CORONA2020,DC=local" `
-LinkEnabled Yes
$GPOID = (Get-GPO -Name "Control Panel Access Denied").Id.ToString()
Copy-Item -Path $POLFilePath"Control Panel Access Denied\*" -Destination "\\alfa\SYSVOL\CORONA2020.local\Policies\{$GPOID}" -Recurse -Force
$RegistryPolPath = "\\$ServerNaam\SYSVOL\$DomeinNaam\Policies\{$GPOID}\User"
Get-ChildItem -Path $RegistryPolPath
$RegPolPath = Join-Path -Path $RegistryPolPath -ChildPath 'Registry.pol'
Parse-PolFile -Path $RegPolPath

# Network Adapter Policies
New-GPO `
-Name "Network Adapter Access Granted" `
-Comment "This GPO grants access to the Network Adapter properties." | New-GPLink `
-Target "OU=CoronaAfdeling,DC=CORONA2020,DC=local" `
-LinkEnabled Yes
$GPOID = (Get-GPO -Name "Network Adapter Access Granted").Id.ToString()
Copy-Item -Path $POLFilePath"Network Adapter Access Granted\*" -Destination "\\alfa\SYSVOL\CORONA2020.local\Policies\{$GPOID}" -Recurse -Force
$RegistryPolPath = "\\$ServerNaam\SYSVOL\$DomeinNaam\Policies\{$GPOID}\User"
Get-ChildItem -Path $RegistryPolPath
$RegPolPath = Join-Path -Path $RegistryPolPath -ChildPath 'Registry.pol'
Parse-PolFile -Path $RegPolPath

New-GPO `
-Name "Network Adapter Access Denied" `
-Comment "This GPO prohibits access to the Network Adapter properties." | New-GPLink `
-Target "OU=Administratie,OU=CoronaAfdeling,DC=CORONA2020,DC=local" `
-LinkEnabled Yes
$GPOID = (Get-GPO -Name "Network Adapter Access Denied").Id.ToString()
Copy-Item -Path $POLFilePath"Network Adapter Access Denied\*" -Destination "\\alfa\SYSVOL\CORONA2020.local\Policies\{$GPOID}" -Recurse -Force
$RegistryPolPath = "\\$ServerNaam\SYSVOL\$DomeinNaam\Policies\{$GPOID}\User"
Get-ChildItem -Path $RegistryPolPath
$RegPolPath = Join-Path -Path $RegistryPolPath -ChildPath 'Registry.pol'
Parse-PolFile -Path $RegPolPath

# No Game Link Policy
New-GPO `
-Name "No Game Link" `
-Comment "This GPO deletes the game link from the Start Menu." | New-GPLink `
-Target "OU=CoronaAfdeling,DC=CORONA2020,DC=local" `
-LinkEnabled Yes
$GPOID = (Get-GPO -Name "No Game Link").Id.ToString()
Copy-Item -Path $POLFilePath"No Game Link\*" -Destination "\\alfa\SYSVOL\CORONA2020.local\Policies\{$GPOID}" -Recurse -Force
$RegistryPolPath = "\\$ServerNaam\SYSVOL\$DomeinNaam\Policies\{$GPOID}\User"
Get-ChildItem -Path $RegistryPolPath
$RegPolPath = Join-Path -Path $RegistryPolPath -ChildPath 'Registry.pol'
Parse-PolFile -Path $RegPolPath

Write-Host -ForegroundColor Yellow "Policies aangemaakt."

# Einde
$Shell = New-Object -ComObject "WScript.Shell"
$Button = $Shell.Popup("Klik op OK om verder te gaan.", 0, "Het script is klaar!", 0)
