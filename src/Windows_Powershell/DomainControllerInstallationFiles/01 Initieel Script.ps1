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

$Computernaam = $IniVariabelen.ALFA.ServerNaam
$InterfaceAlias = $IniVariabelen.ALFA.InterfaceAlias
$IPv4Address = $IniVariabelen.ALFA.IPv4Address
$PrefixLength = $IniVariabelen.ALFA.PrefixLength
$DefaultGateway = $IniVariabelen.ALFA.DefaultGateway
$DNSAdress = $IniVariabelen.ALFA.DNSAdress
$IPv6Address = $IniVariabelen.ALFA.IPv6Address
$IPv6PrefixLength = $IniVariabelen.ALFA.IPv6PrefixLength
$IPv6DefaultGateway = $IniVariabelen.ALFA.IPv6DefaultGateway
$IPv6DNSAddress = $IniVariabelen.ALFA.IPv6DNSAddress

# Windows Update op "disabled" zetten
sc.exe config wuauserv start=disabled
# Status tonen van de service
sc.exe query wuauserv
# Service stoppen
sc.exe stop wuauserv
# Double checken of het echt uitstaat, beginwaarde zou 0x4 moeten zijn
REG.exe QUERY HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wuauserv /v Start

# Installeren van alle benodigde software
Write-Host -ForegroundColor Yellow "Installeren van alle benodigde software."
# Installeren van de AD DS-rol met management tools
Write-Host -ForegroundColor Yellow "AD DS-rol met management tools installeren."
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
# Benodigde Roles & Features installeren en importeren voor Group Policies
Write-Host -ForegroundColor Yellow "Modules en features installeren voor Group Policies."
Install-Module -Name GPRegistryPolicy -Force
Install-WindowsFeature -IncludeAllSubFeature RSAT
Import-Module GroupPolicy
# Benodigde Roles & Features installeren en importeren voor DFS
Write-Host -ForegroundColor Yellow "Modules en features installeren voor DFS."
Install-WindowsFeature FS-DFS-Namespace, RSAT-DFS-Mgmt-Con

# Static IP geven
# NAT = keep default
# 2e adapter:
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

# Naam veranderen
Write-Host -ForegroundColor Yellow "Computernaam aanpassen."
Rename-Computer -NewName $Computernaam -Restart

# Einde
$Shell = New-Object -ComObject "WScript.Shell"
$Button = $Shell.Popup("Klik op OK om verder te gaan.", 0, "Het script is klaar!", 0)
