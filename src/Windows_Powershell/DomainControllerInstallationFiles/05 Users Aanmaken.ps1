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

$UsersCSVPath = '.\CSVs\Users.csv'
$UsersCSV = Import-Csv -Path $UsersCSVPath -Delimiter ";"

$ComputersCSVPath = '.\CSVs\Computers.csv'
$ComputersCSV = Import-Csv -Path $ComputersCSVPath -Delimiter ";"

$DCPath = $IniVariabelen.ALFA.DCPath
$DomeinNaam = $IniVariabelen.ALGEMEEN.DomeinNaam

# Computers maken
Write-Host -ForegroundColor Yellow "Computers aanmaken."
$ComputersCSV | ForEach-Object {
$OUPath = $_.Path
$Path = "$OUPath" + "," +"$DCPath"
New-ADComputer `
 -Name $_.ComputerName `
 -SamAccountName $_.SamAccountName `
 -Path "$Path"
}

# Users maken
Write-Host -ForegroundColor Yellow "Users aanmaken."
$UsersCSV | ForEach-Object {
$upn = ($_.SamAccountName + “@" + $DomeinNaam)
New-ADUser `
 -Name $_."Name" `
 -GivenName $_."GivenName" `
 -Surname $_."Surname" `
 -SamAccountName  $_."SamAccountName" `
 -UserPrincipalName  $upn `
 -Path $_."Path" `
 -AccountPassword (ConvertTo-SecureString “Wachtw00rd” -AsPlainText -force) `
 -ChangePasswordAtLogon $true `
 -Enabled $true `
 -LogonWorkstations $_.AllowedPCs

 #Users aan groep toevoegen
 Add-ADGroupMember `
 -Identity $_.Groups `
 -Members $_.SamAccountName
}

# Einde
$Shell = New-Object -ComObject "WScript.Shell"
$Button = $Shell.Popup("Klik op OK om verder te gaan.", 0, "Het script is klaar!", 0)
