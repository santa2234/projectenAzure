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
$Computernaam = $IniVariabelen.ECHO.ServerNaam
$InterfaceAlias = $IniVariabelen.ECHO.InterfaceAlias
$IPv4Address = $IniVariabelen.ECHO.IPv4Address
$PrefixLength = $IniVariabelen.ECHO.PrefixLength
$DefaultGateway = $IniVariabelen.ECHO.DefaultGateway
$DNSAdress = $IniVariabelen.ECHO.DNSAdress
$IPv6Address = $IniVariabelen.ECHO.IPv6Address
$IPv6PrefixLength = $IniVariabelen.ECHO.IPv6PrefixLength
$IPv6DefaultGateway = $IniVariabelen.ECHO.IPv6DefaultGateway
$IPv6DNSAddress = $IniVariabelen.ECHO.IPv6DNSAddress
$DriveLetter = $IniVariabelen.ECHO.DriveLetter
$ISOFilePath = $IniVariabelen.ECHO.ISOFilePath

# Windows Update op "disabled" zetten
Write-Host -ForegroundColor Yellow "Windows Update op Disabled zetten."
sc.exe config wuauserv start=disabled
# Status tonen van de service
sc.exe query wuauserv
# Service stoppen
sc.exe stop wuauserv
# Double checken of het echt uitstaat, beginwaarde zou 0x4 moeten zijn
REG.exe QUERY HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wuauserv /v Start

# Map maken voor onze ISO files, map invullen met onze ISO files
Write-Host -ForegroundColor Yellow "Map maken voor onze ISO files, map invullen met onze ISO files (let op, dit kopiëren kan lang duren en er is geen progress bar)."
mkdir $DriveLetter":\Iso's"
Copy-Item -Path ".\Iso's\*" -Destination ($DriveLetter + ":\" + $ISOFilePath) -Recurse

# Statisch IP geven
Write-Host -ForegroundColor Yellow "Statisch IP geven."
New-NetIPAddress `
–InterfaceAlias $InterfaceAlias `
-AddressFamily IPv4 `
-IPAddress $IPv4Address `
–PrefixLength $PrefixLength `
-DefaultGateway $DefaultGateway

Set-DnsClientServerAddress `
-InterfaceAlias $InterfaceAlias `
-ServerAddresses $DNSAdress

New-NetIPAddress `
–InterfaceAlias $InterfaceAlias `
-AddressFamily IPv6 `
-IPAddress $IPv6Address `
–PrefixLength $IPv6PrefixLength `
-DefaultGateway $IPv6DefaultGateway

Set-DnsClientServerAddress `
-InterfaceAlias $InterfaceAlias `
-ServerAddresses $IPv6DNSAddress

# Computernaam aanpassen
Write-Host -ForegroundColor Yellow "Computernaam aanpassen."
Rename-Computer -NewName $Computernaam -Restart

# Einde
$Shell = New-Object -ComObject "WScript.Shell"
$Button = $Shell.Popup("Klik op OK om verder te gaan.", 0, "Het script is klaar!", 0)
