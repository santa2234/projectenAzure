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
$WorkstationID = $IniVariabelen.ECHO.WorkstationID

# Image van Windows 10 toevoegen aan WDS
Write-Host -ForegroundColor Yellow "Image van Windows 10 toevoegen aan WDS."

$ImageFile = $DriveLetter + ":\" + $WorkstationPath + "\Boot\LiteTouchPE_x64.wim"
$FileName = $WorkstationID + ".wim"
wdsutil /Verbose /Progress /Add-Image /ImageFile:$ImageFile /ImageType:Boot /Name:$WorkstationID /Filename:$FileName

# Einde
$Shell = New-Object -ComObject "WScript.Shell"
$Button = $Shell.Popup("Klik op OK om verder te gaan.", 0, "Het script is klaar!", 0)
