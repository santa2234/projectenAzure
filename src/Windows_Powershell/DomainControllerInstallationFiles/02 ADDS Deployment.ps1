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

$ADDSDatabasePath = "C:\Windows\NTDS";
$ADDSLogPath = "C:\Windows\NTDS";
$ADDSSysvolPath = "C:\Windows\SYSVOL";
$ADDSDomainMode = "WinThreshold"; # WinTreshold = windows server 2016.
$ADDSForestMode = "WinThreshold"; # WinTreshold = windows server 2016.
$Password = $IniVariabelen.ALGEMEEN.Wachtwoord |ConvertTo-SecureString -AsPlainText -force

$DomeinNaam = $IniVariabelen.ALGEMEEN.DomeinNaam
$NetBiosDomeinNaam = $IniVariabelen.ALGEMEEN.NetBiosDomeinNaam

# AD DS Deployment
Write-Host -ForegroundColor Yellow "AD DS Deployen."
Import-Module ADDSDeployment
Install-ADDSForest `
-SafeModeAdministratorPassword $Password `
-CreateDnsDelegation:$false `
-DatabasePath:$ADDSDatabasePath `
-DomainMode:$ADDSDomainMode `
-DomainName:$DomeinNaam `
-DomainNetbiosName:$NetBiosDomeinNaam `
-ForestMode:$ADDSForestMode `
-InstallDns:$true `
-LogPath:$ADDSLogPath `
-NoRebootOnCompletion:$false `
-SysvolPath:$ADDSSysvolPath `
-Force:$true
 # DomainMode specifieert in welk forest functioneel level je werkt.
 # ForestMode specifieert in welk domein functioneel level je werkt.

# Einde
$Shell = New-Object -ComObject "WScript.Shell"
$Button = $Shell.Popup("Klik op OK om verder te gaan.", 0, "Het script is klaar!", 0)
