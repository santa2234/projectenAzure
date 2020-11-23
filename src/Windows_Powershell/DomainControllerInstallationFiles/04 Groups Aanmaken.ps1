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

$OUCSVPath = '.\CSVs\OrganizationalUnits.csv'
$OUCSV = Import-CSV $OUCSVPath -Delimiter ";"

$GroupsCSVPath = '.\CSVs\Groups.csv'
$GroupsCSV = Import-Csv -Path $GroupsCSVPath -Delimiter ";"

$GroupScope = "global"
$CN = "CN=Users"
$DCPath = $IniVariabelen.ALFA.DCPath

# Groepen aanmaken
Write-Host -ForegroundColor Yellow "Groepen aanmaken."

$GroupsCSV | ForEach-Object {
New-ADGroup `
-Name $_.GroupName `
-GroupScope $GroupScope `
-Path "$CN,$DCPath" `
-Description $_.Description
}

Write-Host -ForegroundColor Yellow "Groepen aanmaken klaar."

# Einde
$Shell = New-Object -ComObject "WScript.Shell"
$Button = $Shell.Popup("Klik op OK om verder te gaan.", 0, "Het script is klaar!", 0)
