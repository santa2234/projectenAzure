# DNS Test Rapport
## Validate config files:
- Main config file is syntactically correct
- Cannot find the file /var/named/corona2020.local
![Not_Found](Not_Found_Corona2020_Local.png)
- service named is running
- Bij de dig-commando's kreeg ik onderstaande error:
![Dig_Time_Out](Dig_Command_Time_Out.png)
![Dig_Time_Out](Dig_Command_Time_Out_2.png)
![Dig_Time_Out](Dig_Command_Time_Out_3.png)
- Na deze commando's besloten om de test te beeindigen omdat telkens dezelfde error terug komt. Hieronder voeg ik nog enkele commando's uit die misschien helpen bij het troubleshooten:
![journalctl](journalctl.png)
![Named_Directory](Named_Directory.png)
