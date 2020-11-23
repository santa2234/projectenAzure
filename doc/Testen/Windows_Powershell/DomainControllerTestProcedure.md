# Testprocedure
## 1. Steek je 'usb' in
  - In VirtualBox ga naar de machine waar je de usb wilt insteken
  - Ga naar details
  - Klik op Shared Folders
  - Klik rechts op de folder met een +
  - Ga in folder path naar de locatie waar de usb is in ons geval zoek je naar .\p3ops-2021-g03\src\Windows_Powershell
  - Vink Auto-Mount aan zodat je usb herkent wordt door je server wanneer deze opstart
### Test
  - Start je server
  - Ga naar 'This pc'
  - Kijk of je usb herkent is en in een shared folder zit
  
## 2. Script 1
  - Ga naar de Shared Folder
  - Rechtermuisklik op het script en klik dan op run with PowerShell
### Test
  - Ga naar je Server Manager naar local host kijken en controleer of de naam van je server is aangepast
  - Controleer of de IPv4 en IPv6-adressen correct zijn ingesteld samen met hun DNS door in de local host op Ethernet te klikken daarna op Ethernet 2 te klikken, properties en controleer daar
  - In de zoekbalk van Windows ga naar services.msc en ga naar Windows Updates en controleer of deze uit staan
## 3. Script 2
  - Ga naar de Shared Folder
  - Rechtermuisklik op het script en klik dan op run with PowerShell
### Test
  - Ga naar je Server Manager naar local host kijken en controleer of de domeinnaam van je server is aangepast
  - Ga naar je Server Manager en kijk ofdat je server nu de DomainController functionaliteit heeft
## 4. Script 3
  - Ga naar de Shared Folder
  - Rechtermuisklik op het script en klik dan op run with PowerShell
### Test
  - Ga naar Tools, Active Directory Users and Computers 
  - Ga naar je domeinnaam
  - Kijk ofdat de Corona Afdeling is aangemaakt en dat deze 5 OU's heeft (IT Administratie, Verkoop, Administratie, Ontwikkeling, Directie)
## 5. Script 4
  - Ga naar de Shared Folder
  - Rechtermuisklik op het script en klik dan op run with PowerShell
### Test
  - Ga naar Tools, Active Directory Users and Computers 
  - Ga naar je domeinnaam
  - Ga naar users
  - Kijk ofdat de de groepen er zijn aangemaakt (IT Administratie, Verkoop, Administratie, Ontwikkeling, Directie)
## 6. Script 5
  - Ga naar de Shared Folder
  - Rechtermuisklik op het script en klik dan op run with PowerShell
### Test
  - Ga naar Tools, Active Directory Users and Computers
  - Ga naar je domeinnaam
  - Ga naar CoronaAfdeling
  - Kijk in iedere afdeling ofdat deze een PC heeft en de users er ook in zitten
  - Ga naar groups
  - Kijk ofdat je users zijn toegevoegd aan de groepen
## 7. Script 6
  - Ga naar de Shared Folder
  - Rechtermuisklik op het script en klik dan op run with PowerShell
### Test
  - Ga naar Tools, Group Policy Management
  - Klik op de Corona2020 forest
  - Bekijk de policies, deze zouden moeten overeen komen met de opgave (soms komen regels voor bij CoronaAfdeling en dan heffen we deze regels op bij de specifieke OU die deze regel niet moet volgen)
## 8. Script 7
  - Ga naar de Shared Folder
  - Rechtermuisklik op het script en klik dan op run with PowerShell
### Test
  - Ga naar Tools, DFS Management
  - Kijk naar de namespace die aangemaakt is
  - Ga naar het pad \\\ALFA\Corona2020Namespace\Home
  - Daar kan je de directories zien van alle users
## Hiermee is je DC volledig getest!
