# Requirements voor beginnen van het testen

1. VM maken met volgende specificaties:
    - Naam = Windows Server 2019 DC (kies je zelf maar hou het nuttig)
    - Type = Microsoft Windows
    - Versie = Windows 2019 (64-bit)
    - 2048 MB RAM toekennen (meer is beter maar je moet 2 servers + een PXE client kunnen runnen)
    - Virtuele harde schijf van het bestandstype VDI met een capaciteit van 50 GB die dynamisch gealloceerd wordt op de fysieke harde schijf maken
    - 128 MB videogeheugen toegekend
    - 1 NAT adapter
    - 1 Internal network adapter
2. Windows Server 2019 installatie-iso invoeren en VM starten
3. Installatiesetup doorlopen en volgende waarden meegeven:
    - Language to install = English (United States)
    - Time and currency format = Dutch (Belgium)
    - Keyboard or input method = Belgian (Period)
    - Windows Server 2019 Standard Evaluation (Desktop Experience)
    - Accept the license terms
    - Custom install
    - Drive 0 -> New
    - Max size -> Apply -> OK
    - Password = azerty.qwerty.123
    - Network discoverable pop-up -> Yes
    - Eject Windows Server 2019 installatie-iso
    - Insert VirtualBox Guest Additions
    - Next -> Next -> Install -> Install -> Finish
4. VM maken met volgende specificaties:
    - Naam = Windows Server 2019 DS (kies je zelf maar hou het nuttig)
    - Type = Microsoft Windows
    - Versie = Windows 2019 (64-bit)
    - 2048 MB RAM toekennen (meer is beter maar je moet 2 servers + een PXE client kunnen runnen)
    - Virtuele harde schijf van het bestandstype VDI met een capaciteit van 50 GB die dynamisch gealloceerd wordt op de fysieke harde schijf maken
    - 128 MB videogeheugen toegekend
    - 1 NAT adapter
    - 1 Internal network adapter
5. Windows Server 2019 installatie-iso invoeren en VM starten
6. Installatiesetup doorlopen en volgende waarden meegeven:
    - Language to install = English (United States)
    - Time and currency format = Dutch (Belgium)
    - Keyboard or input method = Belgian (Period)
    - Windows Server 2019 Standard Evaluation (Desktop Experience)
    - Accept the license terms
    - Custom install
    - Drive 0 -> New
    - Max size -> Apply -> OK
    - Password = azerty.qwerty.123
    - Network discoverable pop-up -> Yes
    - Eject Windows Server 2019 installatie-iso
    - Insert VirtualBox Guest Additions
    - Next -> Next -> Install -> Install -> Finish
###### Editor: Arne Bieseman, Alex Hurckmans  
