# Testprocedure
## Make sure to read the readme's on the download locations of the echo server.
## 1. Steek je 'usb' in
  - In virtualbox ga naar de machine waaar je de usb wilt insteken
  - Ga naar details
  - Klik op shared folders
  - Klik rechts op de folder met een +
  - Ga in folder path naar de locatie waar de usb is in ons geval zoek je naar .\p3ops-2021-g03\src\Windows_Powershell
  - Vink auto-mount aan zodat je usb herkent wordt door je server wanneer deze opstart.
### Test
  - Start je server
  - Ga naar this pc
  - Kijk of je 'usb' herkent is en in een shared folder zit
  
## 2. Script 1
  - Ga naar de shared folder
  - Rechtermuisklik op het script en klik dan op run with powershell
### Test
  - Ga naar je server manager naar local host kijken en controleer of de naam van je server is aangepast
  - Controleer of de IPv4 en IPv6-adressen correct zijn ingesteld samen met hun DNS door in de local host op ethernet te klikken daarna op ethernet 2 te klikken, properties en controlleer daar.
  - In de zoekbalk van windows ga naar services.msc en ga naar windows updates en controleer of deze uit staan
  - Bekijk of de iso's zijn gedownload in de folder c:\Iso's (het zijn er 2)
## 3. Script 2
  - Ga naar de shared folder
  - Rechtermuisklik op het script en klik dan op run with powershell
### Test
  - Ga naar je server manager naar local host kijken en controleer of de domeinnaam van je server is aangepast
## 4. Script 3
  - Ga naar de shared folder
  - Rechtermuisklik op het script en klik dan op run with powershell (Als hij lang blijft hangen druk eens op enter)
### Test
  - Ga naar server manager
  - Kijk ofdat de rollen WSUS en WDS zijn geïnstalleerd
## 5. Script 4
  - Ga naar de shared folder
  - Rechtermuisklik op het script en klik dan op run with powershell
### Test
  - Zoek in de windows zoekbalk naar microsoft deployment workbench
  - Als u deze vindt dan is het script succesvol uitgevoerd
## 6. Script 5
  - Ga naar de shared folder
  - Rechtermuisklik op het script en klik dan op run with powershell
### Test
  - ga naar de deployment workbench
  - Kijk ofdat u server onder deployment shares ziet staan
  - Kijk ofdat onder tasksequence een tasksequence aanwezig is
  - Open de properties van de tasksequence en ga naar task sequence
  - Als er geen errors gegeven worden is dit script goed uitgevoerd
## 7. Script 6
  - Ga naar de shared folder
  - Rechtermuisklik op het script en klik dan op run with powershell
### Test
  - ga naar de deployment workbench
  - Kijk ofdat u workstation onder deployment shares ziet staan
  - Kijk ofdat onder tasksequence een tasksequence aanwezig is
  - Open de properties van de tasksequence en ga naar task sequence
  - Als er geen errors gegeven worden is dit script goed uitgevoerd
 ## 8. Script 7
  - Ga naar de shared folder
  - Rechtermuisklik op het script en klik dan op run with powershell
### Test
  - Ga naar je server manager
  - Klik op tools
  - Ga naar Windows deployment services
  - Klik je server uit
  - Kijk of er onder bootimages de Server bootimage staat
  - Rechtermuisklik, properies
  - Kijk bij DHCP ofdat hij naar all clients verstuurd
 ## 9. Script 8
  - Ga naar de shared folder
  - Rechtermuisklik op het script en klik dan op run with powershell
### Test
  - Ga naar je server manager
  - Klik op tools
  - Ga naar Windows deployment services
  - Klik je server uit
  - Kijk of er onder bootimages de Server bootimage staat
  - Rechtermuisklik, properies
  - Kijk bij DHCP ofdat hij naar all clients verstuurd
## Hiermee is je Deployment server volledig getest
