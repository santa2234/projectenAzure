###opzetting ansible

we hebben 2 virtuele machines in vagrant aangemaakt waarbij
1 machine de ansibleController is.

hierna heb ik een node geïnstalleerd genaamd "dnsserver". Ik heb deze geïnitialiseerd met vagrant maar deze heeft GEEN INSTALLATIE VAN ANSIBLE. Dit omdat deze meer bij de ansible filosofie aansluit i p v local provisioning te gebruiken.

Bij de ssh verbinding hadden we het toch lastig we deden volgende acties als eerst:

    1. We maakten een SSH key op de controlling node (standaard in ~/.ssh/)
    2. We maakten een ssh verbinding als root@192.168.1.3
    3. we kopierenden de .pub file naar de host (handmatig)
    4. ansible kon niet pingen naar de betreffende host

nadien vonden we dat deze volgorde wel successvol was:

    1. We maakten een ssh key op de controlling node
    2. We maakten een ssh verbinding als vagrant@192.168.1.3
    3. we kopierden de .pub file met het copy-ssh-id -i /path/ 192.168.1.3
    4. ansible kon WEL pingen naar de betreffende hosts.


gebruikte commando's

1) displayen van hosts en firewall regels

`ansible --list-host all `
`firewall-cmd --list-all`

2) installatie ssh op guest machine
` yum -y install openssh-server openssh-clients`


3) om de ssh key van guest (controller) naar host (node)
` ssh-copy-id -i /root/.ssh/id_rsa.pub vagrant@192.172.1.3`
(bij dit commando moeten we van root naar root gaan)
`ssh-copy-id -i /root/.ssh/id_rsa.pub root@192.172.1.3`


4) na het uit te voeren hebben we ook volgend commando successvol uitgevoerd:
`ansible dnsserver -b -m service -a "name=sshd \ state=restarted"`

5) ssh verbinding maken met gespecifieerde key
`ssh-copy-id -i ~/.ssh/id_rsa.pub vagrant@192.168.1.3`

6) pingen naar alle ansible hosts
`ansible all -m ping`

vragen

we kunnen vanop afstand geen software installeren met volgend commando:
`ansible testserver -b -m dnsserver name=nginx`
    -> dit omdat wij met yum werken (hier nog oplos voor zoeken)

we hebben de oplossing misschien bijna gevonden we moeten werken met een "yum module"

#extra info voor ontleding

    1. met de het "command module" zouden we arbitraire commando's kunnen uitvoeren op een remote machine zoals we zouden kunnen doen met ssh (enkel het commando wordt doorgestuurd kan gebruikt worden voor snel iets te checken bijv)
        -> dit is blijkbaar de default module, hierover beschikken we al.
    
    gebruikt commando die gebruikt maakt van het "command" module

        ansible dnsserver -a uptime
    output:


    2. het niet kunnen uitvoeren van volgend ansible-commando:
        ansible testserver -b -m dnsserver name=nginx

            dit omdat we met yum werken maar het is niet logisch dat we dit niet kunnen vervangen door een yum install. . . 
`
dnsserver | CHANGED | rc=0 >>
03:33:38 up 42 min,  2 users,  load average: 0.00, 0.01, 0.05
`

    2. we kunnen nog verschillende ansible commando's gebruiken:
        - ansible testserver -b -m apt -a "name=nginx"
            -> hiermee installeren we nginx op de host machine

extra info ter herhaling
    1. we vinden de error logs in /var/log/syslog

