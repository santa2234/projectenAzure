# Labo project systeembeheer

NOTA:
- Enkel switch 1 en Router 1 commando's uitgevoerd in packet tracer
- Anderen kunnen zo oefenen/fouten vinden bij het uitvoeren van de andere
- Wachtwoorden: cisco en class

Vragen:
- Ipv6 LOOPBACK switch: https://community.cisco.com/t5/switching/cannot-configure-ipv6-on-2960/td-p/2865055
- In het labo zelf, moeten passwoorden gebruikt worden?
- Fout bij ip router 3? CAFE -> ACAD? 2001:DB8:CAFE:C::1/64


Mogelijke packet tracer beperkingen:
- transport input ssh telnet -> kunnen niet tegelijk?
- clear ipv6 access-list RESTRICTED-LAN  : de show toont geen nummers + dit commando bestaat niet?
- geen sequence optie in packet tracer (voor ACL)?

## Fysieke opstelling:

3 routers, 3 switches, 3 pc's

- Router 1
  - S0/0/0 -> Router 2: S0/0/0
  - S0/0/1 -> Router 3: S0/0/0
  - G0/1 -> Switch 1: G0/1
  - G0/0 -> Switch 2: G0/1
- Router 2
  - S0/0/1 -> Router 3: S0/0/1
  - Overbodig:
    - S0/0/0 -> Router 1: S0/0/0
- Router 3:
  - G0/1 -> Switch 3 G0/1
  - Overbodig:
    - S0/0/0 -> Router 1: S0/0/1
    - S0/0/1 -> Router 2: S0/0/1


- Switch 1
  - Fa0/6 -> PC-A
  - Overbodig:
    - G0/1 -> Router 1: G0/1
- Switch 2
  - Fa0/18 -> PC-B
  - Overbodig:
    - G0/1 -> Router 1: G0/0
- Switch 3
  - Fa0/18 -> PC-C
  - Overbodig:
    - G0/1 -> Router 3: G0/1

## Setting up ipv6

- Set up PC ip's en default gateway.

| Device |	Interface |	IP Address |	Default Gateway |
| --- |	--- | --- |	--- |
  R1 (FE80::1)
  |	  |		S0/0/0(DCE) |		2001:DB8:AAAA:1::1/64  |		N/A |
  |		|	S0/0/1 |		2001:DB8:AAAA:3::1/64 |		N/A |
  |	  |	G0/0 |		2001:DB8:ACAD:B::1/64 |	 	N/A |
  |	  |	G0/1 |		2001:DB8:ACAD:A::1/64  |		N/A |
  R2 (FE80::2)
  |	  |		S0/0/0 |		2001:DB8:AAAA:1::2/64  |		N/A |
  |	  |		S0/0/1(DCE)	 |	2001:DB8:AAAA:2::2/64  |		N/A  |
  |	  |	Lo1	 |	2001:DB8:AAAA:4::1/64	 |	N/A  |
  R3 (FE80::3)
  |	  |	S0/0/0(DCE)	 |	2001:DB8:AAAA:3::2/64	 |	N/A |
  |	  |	S0/0/1 |		2001:DB8:AAAA:2::1/64  |		N/A |
  |	  |		G0/1	 |	2001:DB8:CAFE:C::1/64  |		N/A |
  |	S1	 |	VLAN1	 |	2001:DB8:ACAD:A::A/64  |		N/A |
  |	  S2	 |	VLAN1	 |	2001:DB8:ACAD:B::A/64	 |	N/A |
  |	  S3	 |	VLAN1	 |	2001:DB8:ACAD:C::A/64	 |	N/A |
  |	  PC-A	 |	NIC	 |	2001:DB8:ACAD:A::3/64 	 |	FE80::1 |
  |	PC-B	 |	NIC	 |	2001:DB8:ACAD:B::3/64	 |	FE80::1 |
  |	PC-C	 |	NIC	 |	2001:DB8:ACAD:C::3/64	 |	FE80::3 |

## Basic Switch setup

- no ip domain-lookup
- hostname ...
- ip domain-name ccna-lab.com
- service password-encryption
- banner motd #Toegang voor onbevoegden is verboden#
- username admin secret classadm
- enable secret class
- line con 0
  - password cisco
  - login
  - logging synchronous
- crypto key generate rsa
  - 1024
- line vty 0 15
  - login local
  - transport input ssh
  - transport input telnet
- copy running-config startup-config

-------------LUKT NIET (nog fixen)-----------------
- int vlan 1
  - ipv6 address 2001:DB8:ACAD:A::A/64
  - no shutdown



## Basic Router setup
 - no ip domain-lookup
 - hostname ...
 - ip domain-name ccna-lab.com
 - service password-encryption
 - banner motd #Toegang voor onbevoegden is verboden#
 - username admin secret classadm
 - enable secret class
 - line con 0
  - password cisco
  - login
- crypto key generate rsa
  - 1024
- line vty 0 4
  - login local
  - transport input ssh
  - transport input telnet
- copy running-config startup-config

## Ipv6 op routers

### Router 1
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
  - copy running-config startup-config

### Router 2
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
  - copy running-config startup-config

### Router 3
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
  - copy running-config startup-config

## Checking connectivity

PC-A
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

PC-B
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

PC-C
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

We pingen hier niet naar andere PC's.
Windows PC's blokkeren immers pings.
We pingen naar de default gateway om zo toegang tot hun router te bewijzen.
Daarna wordt er naar de default gateway van andere PC's gepingt om connectie naar dat netwerk te bewijzen.

## Configuring ACLs
R1:
- ipv6 access-list RESTRICT-VTY
  - permit tcp 2001:DB8:ACAD:A::/64 any eq telnet { OF permit tcp 2001:DB8:ACAD:A::/64 any} ???VRAGEN???
  - permit tcp any any eq 22
  {Implicit deny all}
- line vty 0 4
  - ipv6 traffic-filter RESTRICT-VTY in {or ipv6 access-class RESTRICT-VTY in}
- show line 0 4

PC-B
- via putty: telnet selecteren met ip 2001:DB8:ACAD:B::1 en port 23

PC-A
- via putty: telnet selecteren met ip 2001DB8:ACAD:A::1 en port 23

R1:
- ipv6 access-list RESTRICTED-LAN
  - deny tcp any 2001:DB8:ACAD:A::/64 eq telnet
  - permit ipv6 any any
- interface g0/1
  - ipv6 traffic-filter RESTRICTED-LAN out

PC-A
- via putty: telnet selecteren met ip 2001:DB8:ACAD:A::A en port 23 -> zou moeten werken

PC-B
- via putty: telnet selecteren met ip 2001:DB8:ACAD:A::A en port 23 -> zou niet mogen werken

PC-C
- via putty: telnet selecteren met ip 2001:DB8:ACAD:A::A en port 23 -> zou niet mogen werken
- via putty: ssh selecteren met ip 2001:DB8:ACAD:A::A -> zou moeten werken

R1:
- show ipv6 access-list RESTRICTED-LAN
- clear ipv6 access-list RESTRICTED-LAN
- show ipv6 access-list RESTRICTED-LAN {nummers zouden gereset moeten zijn}

R1:
- interface g0/1
  - no ipv6 traffic-filter RESTRICTED-LAN out
- show access-lists
- ipv6 access-list RESTRICTED-LAN
  - permit tcp 2001:db8:acad:b::/64 host 2001:db8:acad:a::a eq 23 sequence 15
{Gevolg: laat telnet toe vanuit het netwerk 2001:db8:acad:b::/64 (waartoe PC-B behoort) naar S1 }
  - permit tcp any host 2001:db8:acad:a::3 eq www
- show access-list RESTRICTED-LAN
- ipv6 access-list RESTRICTED-LAN
  - no permit tcp any host 2001:DB8:ACAD:A::3 eq www
- show access-list RESTRICTED-LAN
- interface g0/1
  - ipv6 traffic-filter RESTRICTED-LAN out

PC-B
  - via putty: telnet selecteren met ip 2001:DB8:ACAD:A::A en port 23 -> zou moeten werken

Sources:
- https://www.cisco.com/c/en/us/td/docs/switches/lan/catalyst2960xr/software/15-2_5_e/configuration_guide/b_1525e_consolidated_2960xr_cg/configuring_ipv6_acls.html#reference_80896D5032C94AC39D40B88614A73C33
- https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/sec_data_acl/configuration/12-4t/sec-data-acl-12-4t-book/sec-cntrl-acc-vtl.html
- https://www.cisco.com/c/en/us/support/docs/smb/switches/Cisco-Business-Switching/kmgmt-2243-access-an-smb-switch-cli-using-ssh-or-telnet.html
- https://community.cisco.com/t5/routing/ipv6-acl/td-p/3876534
