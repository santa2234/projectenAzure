# Testprocedure
# Make sre to read the readme's on the download locations of the echo server.## 1. Steek je 'usb' in
### Rapport
- De 'usb' zit erin.

## 2. Script 1
### Test
  - Server: 'echo'
  - IPv4: 192.168.1.133, DNS: 192.168.1.129
  - IPv6: FE80:0:0:2::5, DNS: 2001:4860:4860:0:0:0:0:8888
  - Windows Updates staan uit
  - Iso's gedownload
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
