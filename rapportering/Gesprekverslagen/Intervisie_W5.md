# Verslag overleg

|                     |                   |
|--------------------:|:------------------|
|            **Week** | 5                 |
|           **Datum** | 2000-10-19, 15:00 |
|        **Aanwezig** | Arne Bieseman, Maxime coppens, Alex Hurckmans, Santi Meremans, Pattyn Fleur en Lana Sakkoul|
| **Verontschuldigd** | /                 |
|         **Afwezig** | /                 |
|    **Verslaggever** |                   |

## Agenda

- Agendapunt 1
- Agendapunt 2
- Varia

## Agendapunt 1
Windows Server (DC):
  -Voor het aanmaken van de policies en toekennen aan de OU's, dit is een many to many relatie, hoe zouden wij dit in variabelen/csv moeten steken?
  -We maken de policies aan en we kennen ze toe aan de juiste OU's maar de betekenis van de policy (de inhoud) kunnen we niet aanpassen. (Alle voorbeelden starten met een reeds gemaakte policy)
  -We zoeken de HKEY-current user voor game link uit te schakelen op maar die is er niet (https://getadmx.com/?Category=Windows_10_2016&Policy=Microsoft.Policies.StartMenu::NoGamesFolderOnStartMenu)


## Agendapunt 2
Labo Netwerken:
- Packet Tracer beperkingen:
  - Ipv6 LOOPBACK switch: https://community.cisco.com/t5/switching/cannot-configure-ipv6-on-2960/td-p/2865055
  - transport input ssh telnet -> Kan het zijn dat deze in Packet Tracer niet tegelijk toegelaten kunnen worden?
  - clear ipv6 access-list RESTRICTED-LAN  : de show toont geen nummers en dit commando bestaat niet?
  - geen sequence optie in packet tracer (voor ACL)?

Live labo:
- In het labo zelf, moeten wachtwoorden gebruikt worden? => Best geen wachtwoorden gebruiken
- Fout bij ip router 3? CAFE -> ACAD? 2001:DB8:CAFE:C::1/64 => Inderdaad, aanpassen.

## Agendapunt 3
Netwerken:
- Hoeveel hosts moeten er mogelijk zijn in het gastnetwerk?
- Hoeveel werkstations zijn er voor het personeel?
=> Zelf voldoende toevoegen

## Agendapunt 4
Netwerken:
- DHCP? Wie voorziet er dit?
=> Best practice: apart toevoegen.


## Varia



## Actiepunten

| Wat | Wie | Deadline |
|:----|:----|:---------|
|  Aanpassen Labo Netwerken   |  Fleur   |     26/10/2020     |
| Beperkingen Packet Tracer navragen bij lector CN | Fleur | 21/10/2020 |
