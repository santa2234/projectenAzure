# IPv4

##VLAN 20: Interne Servers
6 hosts
192.168.1.129 - 192.168.1.134
192.168.1.128/29        255.255.255.248


##VLAN 30: Werkstations Personeel
254 hosts
192.168.0.1 - 192.168.0.254
192.168.0.0/24            255.255.255.0


##VLAN 40: Gastnetwerk
126 hosts
192.168.1.1 - 192.168.1.126
192.168.1.0/25        255.255.255.192


##VLAN 50: Verbinding naar routernetwerk en buitenwereld
2 hosts
192.168.1.137 - 192.168.1.142
192.168.1.136/30        255.255.255.252


# IPv6

##VLAN 20: Interne Servers
fe80:0000:0000:0002:0000:0000:0000:0000 - fe80:0000:0000:0002:ffff:ffff:ffff:ffff


##VLAN 30: Werkstations Personeel
fe80:0000:0000:0003:0000:0000:0000:0000 - fe80:0000:0000:0003:ffff:ffff:ffff:ffff


##VLAN 40: Gastnetwerk
fe80:0000:0000:0004:0000:0000:0000:0000 - fe80:0000:0000:0004:ffff:ffff:ffff:ffff


##VLAN 50: Verbinding naar routernetwerk en buitenwereld
fe80:0000:0000:0005:0000:0000:0000:0000 - fe80:0000:0000:0005:ffff:ffff:ffff:ffff
