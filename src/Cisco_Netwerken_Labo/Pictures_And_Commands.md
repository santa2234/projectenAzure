# Pictures and Commands

Notes:
- Noodzakelijk bij de switches is de loopback interface
- copy run start is telkens weggelaten omdat we werken binnen een labo-opstelling


# Configure PC's
## PC-A:
- Ip: 2001:DB8:ACAD:A::3/64
- Default Gateway: FE80::1

> START STOP 1

- ping 2001:DB8:ACAD:A::1 (Default Gateway)
- ping 2001:DB8:ACAD:B::1 (PC-B)
- ping 2001:DB8:CAFE:C::1 (PC-C)
- ping 2001:DB8:AAAA:1::2 (R2)
- Probeer ook eens een SSH connectie op te zetten naar een router via bovenstaande ip's. (Via Putty -> TCP/IP)
  - Username: admin
  - Password: classadm
- Probeer ook eens een telnet connectie op te zetten naar een router via bovenstaande ip's. (via putty: telnet -> port 23)
  - Username: admin
  - Password: classadm

> EINDE STOP 1

> START STOP 2

PC-A
- via putty: telnet selecteren met ip 2001:DB8:ACAD:A::1 en port 23 -> moet lukken

> EINDE STOP 2

> START STOP 3

- via putty: telnet selecteren met ip 2001:DB8:ACAD:A::A en port 23 -> zou moeten werken

> EINDE STOP 3


## PC-B:
- Ip: 2001:DB8:ACAD:B::3/64
- Default Gateway: FE80::1

> START STOP 1

- ping 2001:DB8:ACAD:B::1 (Default Gateway)
- ping 2001:DB8:ACAD:A::1 (PC-A)
- ping 2001:DB8:CAFE:C::1 (PC-C)
- ping 2001:DB8:AAAA:1::2 (R2)
- Probeer ook eens een SSH connectie op te zetten naar een router via bovenstaande ip's. (Via Putty -> TCP/IP)
  - Username: admin
  - Password: classadm
- Probeer ook eens een telnet connectie op te zetten naar een router via bovenstaande ip's. (via putty: telnet -> port 23)
  - Username: admin
  - Password: classadm

> EINDE STOP 1

> START STOP 2

PC-B
- via putty: telnet selecteren met ip 2001:DB8:ACAD:B::1 en port 23 -> zou niet mogen lukken

> EINDE STOP 2

> START STOP 3

- via putty: telnet selecteren met ip 2001:DB8:ACAD:A::A en port 23 -> zou niet mogen werken

> EINDE STOP 3

> BEGIN STOP 4

PC-B
- via putty: telnet selecteren met ip 2001:DB8:ACAD:A::A en port 23 -> zou moeten werken

> EINDE STOP 4

## PC-C:
- Ip: 2001:DB8:ACAD:C::3/64
- Default Gateway: FE80::3

> START STOP 1

- ping 2001:DB8:CAFE:C::1 (Default Gateway)
- ping 2001:DB8:ACAD:B::1 (PC-B)
- ping 2001:DB8:ACAD:A::1 (PC-A)
- ping 2001:DB8:AAAA:1::2 (R2)
- Probeer ook eens een SSH connectie op te zetten naar een router via bovenstaande ip's. (Via Putty -> TCP/IP)
  - Username: admin
  - Password: classadm
- Probeer ook eens een telnet connectie op te zetten naar een router via bovenstaande ip's. (via putty: telnet -> port 23)
  - Username: admin
  - Password: classadm

> EINDE STOP 1

> START STOP 3

- via putty: telnet selecteren met ip 2001:DB8:ACAD:A::A en port 23 -> zou niet mogen werken
- via putty: ssh selecteren met ip 2001:DB8:ACAD:A::A -> zou moeten werken

> EINDE STOP 3

# Configure switches

## Switch 1:
- no ip domain-lookup
- hostname S1
- ip domain-name ccna-lab.com
- banner motd #Toegang voor onbevoegden is verboden#
- line con 0
  - logging synchronous
- crypto key generate rsa
  - 1024
- line vty 0 15
  - login local
  - transport input ssh telnet
- int vlan 1
  - ipv6 address 2001:DB8:ACAD:A::A/64
  - no shutdown

> Neem een foto van de running config. [S1_RunningConfig.png]

> Wacht tot go van PC's om connectiviteit te controleren (STOP 1)

## Switch 2:
- no ip domain-lookup
- hostname S2
- ip domain-name ccna-lab.com
- banner motd #Toegang voor onbevoegden is verboden#
- line con 0
  - logging synchronous
- crypto key generate rsa
  - 1024
- line vty 0 15
  - transport input ssh telnet
- int vlan 1
  - ipv6 address 2001:DB8:ACAD:B::A/64
  - no shutdown

> Wacht tot go van PC's om connectiviteit te controleren (STOP 1)

## Switch 3:
- no ip domain-lookup
- hostname S3
- ip domain-name ccna-lab.com
- banner motd #Toegang voor onbevoegden is verboden#
- line con 0
  - logging synchronous
- crypto key generate rsa
  - 1024
- line vty 0 15
  - transport input ssh telnet
- int vlan 1
  - ipv6 address 2001:DB8:ACAD:C::A/64
  - no shutdown

> Wacht tot go van PC's om connectiviteit te controleren (STOP 1)

# Routers

## Router 1:
- no ip domain-lookup
- hostname ...
- ip domain-name ccna-lab.com
- banner motd #Toegang voor onbevoegden is verboden#
- line con 0
 - login
- crypto key generate rsa
 - 1024
- line vty 0 4
 - transport input ssh telnet
- ipv6 unicast-routing
- interface S0/0/0
  - ipv6 address 2001:DB8:AAAA:1::1/64
  - ipv6 address FE80::1 link-local
  - no shutdown
- herhaal voor onderstaande interfaces
  | R1 (FE80::1) | | link-local | area |
  |---|---|---|
  |		S0/0/0(DCE) |		2001:DB8:AAAA:1::1/64 | FE80::1 | 0 |
  |	S0/0/1 |		2001:DB8:AAAA:3::1/64 | FE80::1 | 0 |
  |	G0/0 |		2001:DB8:ACAD:B::1/64 | FE80::1| 0 |
  |	G0/1 |		2001:DB8:ACAD:A::1/64  | FE80::1| 0 |
- interface s0/0/0
  - clock rate 128000
- ipv6 router ospf 1
  - router-id 1.1.1.1
  - passive-interface G0/0
  - passive-interface G0/1
- in each interface:
  - ipv6 ospf 1 area 0

> Neem een foto van de running config. [R1_RunningConfig.png]

> Wacht tot go van PC's om connectiviteit te controleren (STOP 1)

- ipv6 access-list RESTRICT-VTY
  - permit tcp 2001:DB8:ACAD:A::/64 any eq telnet
  - permit tcp any any eq 22
  {Implicit deny all}
- line vty 0 4
  - ipv6 access-class RESTRICT-VTY in

> Wacht tot go van PC's om ACL te controleren (STOP 2)

- show line 0 4

> Neem een foto van het resultaat van het show-commando [R1_ACL_RESTRICT_VTY.png]

- ipv6 access-list RESTRICTED-LAN
  - deny tcp any 2001:DB8:ACAD:A::/64 eq telnet
  - permit ipv6 any any
- interface g0/1
  - ipv6 traffic-filter RESTRICTED-LAN out

> Wacht tot go van PC's om ACL te controleren (STOP 3)

- show ipv6 access-list RESTRICTED-LAN

> Neem een foto van het resultaat van het show-commando [R1_ACL_RESTRICTED_LAN_1.png]

- clear ipv6 access-list RESTRICTED-LAN
- show ipv6 access-list RESTRICTED-LAN {nummers zouden gereset moeten zijn}

> Neem een foto van het resultaat van het show-commando [R1_ACL_RESTRICTED_LAN_2.png]

- interface g0/1
  - no ipv6 traffic-filter RESTRICTED-LAN out
- show access-lists

> Neem een foto van het resultaat van het show-commando [R1_ACL_RESTRICTED_LAN_3.png]

- ipv6 access-list RESTRICTED-LAN
  - permit tcp 2001:db8:acad:b::/64 host 2001:db8:acad:a::a eq 23 sequence 15
{Gevolg: laat telnet toe vanuit het netwerk 2001:db8:acad:b::/64 (waartoe PC-B behoort) naar S1 }
  - permit tcp any host 2001:db8:acad:a::3 eq www
- show access-list RESTRICTED-LAN

> Neem een foto van het resultaat van het show-commando [R1_ACL_RESTRICTED_LAN_4.png]

- ipv6 access-list RESTRICTED-LAN
  - no permit tcp any host 2001:DB8:ACAD:A::3 eq www
- show access-list RESTRICTED-LAN

> Neem een foto van het resultaat van het show-commando [R1_ACL_RESTRICTED_LAN_5.png]

- interface g0/1
  - ipv6 traffic-filter RESTRICTED-LAN out

> STOP 4

## Router 2:
- no ip domain-lookup
- hostname R2
- ip domain-name ccna-lab.com
- banner motd #Toegang voor onbevoegden is verboden#
- line con 0
 - login
- crypto key generate rsa
 - 1024
- line vty 0 4
 - transport input ssh telnet
- ipv6 unicast-routing
- interface S0/0/0
  - ipv6 address 2001:DB8:AAAA:1::2/64
  - ipv6 address FE80::2 link-local
  - no shutdown
- herhaal voor onderstaande interfaces
  | R2 (FE80::2) | | Link-local | Area |
  |---|---|---|---|
  |		S0/0/0 |		2001:DB8:AAAA:1::2/64  |		FE80::2 | 0 |
  |		S0/0/1(DCE)	 |	2001:DB8:AAAA:2::2/64  |		FE80::2  | 0 |
  |	Lo1	 |	2001:DB8:AAAA:4::1/64	 |	N/A  | 0 |
- interface S0/0/1
  - clock rate 128000
- ipv6 route ::/0 Lo1
- ipv6 router ospf 1
  - router-id 2.2.2.2
  - default-information originate
- in each interface:
  - ipv6 ospf 1 area 0

> Neem een foto van de running config. [R2_RunningConfig.png]

> Wacht tot go van PC's om connectiviteit te controleren (STOP 1)

## Router 3:
- no ip domain-lookup
- hostname R3
- ip domain-name ccna-lab.com
- banner motd #Toegang voor onbevoegden is verboden#
- line con 0
 - login
- crypto key generate rsa
 - 1024
- line vty 0 4
 - transport input ssh telnet
- ipv6 unicast-routing
- interface S0/0/0
  - ipv6 address 2001:DB8:AAAA:3::2/64
  - ipv6 address FE80::3 link-local
  - no shutdown
- herhaal voor onderstaande interfaces
| R3 (FE80::3) | | link-local | area |
|---|---|---|---|
|	S0/0/0(DCE)	 |	2001:DB8:AAAA:3::2/64	| FE80::3 |	0 |
|	S0/0/1 |		2001:DB8:AAAA:2::1/64  | FE80::3 |		0 |
|		G0/1	 |	2001:DB8:CAFE:C::1/64  | FE80::3 |		0 |
- interface S0/0/0
  - clock rate 128000
- ipv6 router ospf 1
  - router-id 3.3.3.3
  - passive-interface G0/1
- in each interface:
  - ipv6 ospf 1 area 0

> Neem een foto van de running config. [R3_RunningConfig.png]

> Wacht tot go van PC's om connectiviteit te controleren (STOP 1)
