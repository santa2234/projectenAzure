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

ForEach($OU in $OUCSV){
 
try {

#OU Naam en Pad uit OUCSV halen
$OUName = $OU.Name

if($OU.Path -eq ""){

$OUPath = $IniVariabelen.ALFA.DCPath;

} else {

$OUPath = $OU.Path + "," + $IniVariabelen.ALFA.DCPath

}

# Naam en pad van de OU tonen
Write-Host -Foregroundcolor Yellow "Gekozen naam: $OUName, Gekozen pad: $OUPath"
 
# OU aanmaken
New-ADOrganizationalUnit `
 -Name "$OUName" `
 -Path "$OUPath" `
 -ProtectedFromAccidentalDeletion $false
 
# Succesbericht tonen
Write-Host -ForegroundColor Yellow "OU $OUName succesvol aangemaakt!"

} catch {

Write-Host $error[0].Exception.Message

}
 
}

# Einde
$Shell = New-Object -ComObject "WScript.Shell"
$Button = $Shell.Popup("Klik op OK om verder te gaan.", 0, "Het script is klaar!", 0)
