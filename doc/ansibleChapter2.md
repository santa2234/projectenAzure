#CHAPTER 2 LINUX ANSIBLE

##prerequisites om een playbook te runnen
    1) poort 8080 met 80 mappen
    2) poort 8443 met 443 mappen
        -> wij moesten dit anders doen omdat we anders een collide haddeen wij hebben volgende statements gebruikt:
        
`config.vm.network "forwarded_port", guest:80, host:420` 
`config.vm.network "forwarded_port", guest:443, host:024`   
    -> het kan zijn dat we dit niet in de vagrantfile mogen definieren maar in provisioning maar eigenlijk doen we dit al aangezien we beide machines aparte definiering gegeven hebben.
         
    -> gediefinieerd in vagrantfile
    -> we kregen hier ook een foutmelding dat soommige systemen niet toelaten op privileged ports te gebruiken.
    -> checken of deze poorten op de machine daadwerkelijk open staan

vooraleer we hiermee starten kijken we met welke poorten onze machines zijn verbonden door volgend commando:
`vagrant port ansibleController`
en
`vagrant port dnsserver`

IK DENK dat dit wel te maken heeft over de poortvgerbindingen van mijn fysieke hostcomputer en mijn virutele machine en NIET de virtuele machines onderling.

we passen de vagrant file aan en destroyen en uppen opnieuw onze machines
hiervoor nemen we eerst een backup van de aangepaste lijnen van onze ansible files:

1) /etc/ansible/hosts
`dnsserver ansible_host=192.168.1.3 ansible_port=22`

2) /etc/ansible/ansible.cfg 

[defaults]

remote_user = vagrant
private_key_file = ~/.ssh/id_rsa
# some basic default values...

inventory      = /etc/ansible/hosts
library        = /usr/share/my_modules/
module_utils   = /usr/share/my_module_utils/
ansible_user   = vagrant
#remote_tmp     = ~/.ansible/tmp
#local_tmp      = ~/.ansible/tmp
#plugin_filters_cfg = /etc/ansible/plugin_filters.yml
#forks          = 5
#poll_interval  = 15
#sudo_user      = root
#ask_sudo_pass = True
#ask_pass      = True
transport      = smart
remote_port    = 22
#module_lang    = C
#module_set_locale = False


## ONTLEDING ANSIBLE.CFG
locaties ansible.cfg deze locaties worden ook volgens chronologische volgorde afgegaan:
    1. File specified by the ANSIBLE_CONFIG environment variable 
    2. ./ansible.cfg (ansible.cfg in the current directory) 
    3. ~/.ansible.cfg (.ansible.cfg in your home directory) 
    4. /etc/ansible/ansible.cfg

*best practic: zet je ansible.cfg in een hidden folder*


we kunnen zien welke config file ansible gebruikt door volgend commando uit te voeren:
`ansible --version`


# poort openen op ubuntu systemen WERKT NIET

GEWOON IN FILE ETC/SERVICES


#commando's uitvoeren op een ansible node

we kunnen nu wel commando's uitlezen (wel enkel nog maar gewerkt om .txt files etc uit te lezen)
`ansible dnsserver -a "tail /home/laurens.txt"`

Dit is in het boek anders gedefinieerd maar wij werken met een centos systeem en niet met een ubuntu systeem.
`ansible dnsserver -b -a "tail /var/log/messages"`

maken van een directory op node (dnsserver), de -b option geeft root
access
`ansible -m shell -b -a 'mkdir -p /home/ditisuwmoeder' dnsserver`



## Installatie nginx op centos machine

    -> dit is moeilijker dan op een ubuntu machine omdat ubuntu meer software meekrijgt

we moeten handmatig een repository configuration file maken voordat we nginx kunnen installeren. We gebruiken volgend commando:



#De inventory

Dit is de file waar de HOSTS zijn gedefinieerd. het default pad is hier:
`/etc/ansible/hosts`

de ansible_user die wordt meegegeven wordt de user die gaat inloggen via de ssh verbinding.

voorbeeld hosts:
[app]

111.111.111.111 ansible_user=ubuntu
222.222.222.222 ansible_user=ubuntu

Wanneer we een playbook starten kunnen we de inventory meegeven op 2 manieren:

    1) we specifieren de inventory file handmatig met de -i option.
    2) we specifieren de inventory file in de ansible.cfg file
        -> indien deze manier dan wordt deze in de [defaults] bijgevoegd.

[defaults]
inventory = ./hosts

#installatie nginx
we moeten een configuratiefile aanmaken dit doen we als volgt (configuratie voor centos 7):

`$ vi /etc/yum.repos.d/nginx.repo`

de inhoud ziet eruit als volgt:

[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/mainline/centos/7/$basearch/
gpgcheck=0
enabled=1


we moeten ook nog een directory maken die missende is. Dit weer omdat we geen ubuntu systeem gebruiken.
vraag: (het gaat erover dat op centos de directory sites-enabled er niet default inzit dit moet nog aangemaeakt worden)

I installed Nginx on Centos 6 and I am trying to set up virtual hosts. The problem I am having is that I can't seem to find the /etc/nginx/sites-available directory.

Is there something I need to do in order to create it? I know Nginx is up and running because I can browse to it.


antwoord:
            Well, I think nginx by itself doesn't have that in its setup, because the Ubuntu-maintained package does it as a convention to imitate Debian's apache setup. You could create it yourself if you wanted to emulate the same setup.

            Create /etc/nginx/sites-available and /etc/nginx/sites-enabled and then edit the http block inside /etc/nginx/nginx.conf and add this line

            include /etc/nginx/sites-enabled/*;

#Aanpassen default configuration file nginx
  Misschien kunnen we ook gewoon de default configuration van nginx aanpassen (indien dit geen errors geeft). Deze bevindt zich in: `/etc/nginx/conf.d`


#Shrijven van configuratie file (nginx)

Dit is een template file. Die wordt geparsed door ansible voor uploaden. heeft een .tpl extensie. DIT IS WEL VOOR UBUNTU DISTRIBUTIE

We hebben een voorbeeld template gevonden op internet die we zullen gebruiken voor testen. Deze hebben we gevonden op https://codelike.pro/how-to-configure-nginx-using-ansible-on-ubuntu/



#Start van playbook (automatisatie)

automatisatie van nginx webserver:

1) Overschrijven van een Nginx configuration file
    -> dit doen we omdat we natuurlijk niet de default configuratie
    van nginx willen.
we vinden dit niet op de plaats van het boek maar in
`/etc/nginx/nginx.conf`

nu we de github voorbeelden bekijken bedenken we ons dat de playbooks of alleszinds handlers, tasks en templates zich bevinden in de roles map van /etc/ansible

---> hier gaan we morgen mee verder.

#Maken van playbook

informatie die we gevonden hebben inzake playbooks met centos bevindt zich:
https://www.centlinux.com/2019/09/install-ansible-use-playbooks-centos-7.html

hieronder vinden we een voorbeeld van een ansible playbook voor een centos
distributie grote verschil met ubuntu is de package manager die verschilt

---
 - hosts: lighttpd-webservers
   user: root
   vars:
    myhomepage: '<html><h1>Apache installed using Ansible</h1></html>'
   tasks:
    - name: Installing EPEL yum Repository
      action: yum name=epel-release state=installed

    - name: Installing Lighttpd Server
      action: yum name=lighttpd state=installed

    - name: Configure Lighttpd Server
      replace:
       path: /etc/lighttpd/lighttpd.conf
       regexp: 'server.use-ipv6 = "enable"'
       replace: 'server.use-ipv6 = "disable"'
       backup: yes

    - name: Create Index.html File.
      copy:
       dest: /var/www/lighttpd/index.html
       content: '{{ myhomepage }}'
       backup: yes

    - name: Allow HTTPS Service in Linux Firewall
      firewalld:
       service: http
       permanent: yes
       state: enabled

    - name: Restart Lighttpd service
      service:
       name: lighttpd
       enabled: yes
       state: restarted

    - name: Restart Firewalld service
      service:
       name: firewalld
       state: restarted

---> de port forwarding die op de vagrantfile is geschreven zullen wij in provisioning moeten toepassen. Dit kan zijn omdat we geen root rechten hebben onderstaande link 


#verschillende soorten playbooks

onze bedoeling was dus om een volledige test omgeving op te zetten met vagrant
en ansible te testen. Wij beperken ons tot de installatie van software en de installatie dus niet de configuratie. Misschien kunnen we dit later ook automatiseren.

feitjes: 
 - ansible zet zich om naar JSON
 - een valid JSON file is ook een valid YAML file
 - bij een task gaat de host computer een script genereren dit kopieren naar de guest en die daar uitvoeren.
 - een play is een ding dat hosts connect aan tasks (met ssh dan neem ik aan)
 - één play is in een playbook: (zonder slash dit is voor de kleur van markdown)
 / - name: install mariadb
      action: yum name=mariadb state=installed

 - je kan een playbook in het midden starten hiervoor moet je wel names gebruiken bij jouw plays
 
 - ansible heeft man pages. je kan deze gaan bekijken met volgend commando:
`ansible-doc`

 - wanneer ansible de uitvoer geeft van het playbook, dan betekend ok dat de software er al op stond, zegt het changed dan heeft hij het er op gezet.




#playbook installatie dnssofware
- name: Configureer dns server
  hosts: servers
  become: True
  tasks:
    - name: install mariadb
      action: yum name=mariadb state=installed
    - name: install bind
      action: yum name=bind state=installed
    - name: install bind-utils
      action: yum name=bind-utils


#Playbook uitgevoerd

ons playbook voert voor het eerst uit. We zijn dit bekomen omdat we een syntaxfout hadden. We gebruiken GEEN TABS MEER. Altijd spaties zijn de boodschap. Ook de juiste inventory specifieren in ansible.cfg is een mus. Hij zit wel vast in zijn task we gaan nu kijken waarom
kaart het probleem aan:
---> https://stackoverflow.com/questions/55203945/ansible-playbook-stuck-in-task-part
---> indien we het niet vinden kunnen we hem in verbose mode zetten met de -v option.
---> we gaan ook van de vagrant user een sudo user maken misschien is dit ook de reden dat hij niet verder gaat installatie van software is root privileged.
        -> we moeten hem toevoegen aan de wheel group en doen dit op volgende manier:
        
`usermod -aG wheel username`

#actuele uitvoering playbook
-> we hebben een yum update gedaan en deze is succesvol uitgevoerd (voor de eerste keer). Nagenoeg zien we dat onze host zijn ip adres verandert is. We hebben eenzelfdertijd ook de dapterinstellingen moeten wijzigen. We gaan het scenario herhalen om te kijken of de fout bij het playbook lag of bij ons toen we de adapterinstellingen wijzigden.


stap 1) manueel de dnsserver zijn ip - adres veranderen deze file bevindt zich in
`/etc/sysconfig/network-scripts/ifcfg-eth0`

lay out van instellen static ip en default gateway:

TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=dhcp
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=eth0
UUID=e6c06d97-5173-4de4-9728-3fc67cbdf853
DEVICE=eth0
ONBOOT=yes
GATEWAY=192.168.1.2
IPADDR=192.172.1.3
NETMASK=255.255.255.0

Hierna herstarten we het netwerk met
`service network restart`


-------> we gaan kijken of het bootproto op none moet worden gezet we hebben
            deze gewoon weggelaten maar hier is hij niet zo blij mee.

#TRUE vs YES

voor sudo values gebruiken we true, voor de andere gebruiken we yes. Dit is wel het geval bij ubuntu systemen dus controleer of dit bij RHEL systemen eenzelfde is.
Verschillende waarden voor true en false:

YAML truthy
true, True, TRUE, yes, Yes, YES, on, On, ON, y, Y
YAML falsey
false, False, FALSE, no, No, NO, off, Off, OFF, n, N
Module arguments are passed as strings and use Ansible’s internal conventions:
module arg truthy
yes, on, 1, true
module arg falsey
no, off, 0, false


-----> we krijgen nog steeds een fout op onze web-notls.yml file dringend vinden hoe deze moet worden opgelost slide 52 op de PDF
-----> ook zeker deze link bekijken voor playbook te laten runnen https://medium.com/@brad.simonin/learning-ansible-with-centos-7-linux-12461043fd02
-----> extra commando's https://www.liquidweb.com/kb/list-users-centos-7/


we hebben om te testen de inventory hosts in de home directory van de vagrant gebruiker gezet we zien nu dat ansible eerst deze gaat checken en niet meer diegene in /etc/ansible

#cowsay

je kan cowsay installeren voor toffere output te krijgen van je playbook:

If you don’t want to see the cows, you can disable cowsay by setting the ANSIBLE_NOCOWS environment variable like this:
$ export ANSIBLE_NOCOWS=1 You can also disable cowsay by adding the following to your ansible.cfg file:
[defaults] nocows = 1


OPZOEKEN HOE WE IN DE VAGRANTFILE DE NAT AFZETTEN OP DE DNSSERVER EN HIJ DE ANSIBLECONTROLLER ALS DEFFAULT GATEWAY GEBRUIKT VIA VAGRANTFILE


#TLS support

TLS (= transport layer security) dit is een encryptie protocol die communicatie tussen computers ver het internet beveiligen (je kan dit een verbeterde versie van ssh noemen).

stap 1) map voor tls certificaat aanmaken

  - we maken in onze ansible directory een map files

stap 2) generen van certificaat in map

je kan dit commmando ook uitvoeren met enkel deze statement hij zal je dan om de info die wij als parameters meegeven gewoon vragen:
openssl req -x509 -nodes -days 3650 -newkey rsa:2048

je kan ook parameters meegeven als volgt:

 - openssl req -x509 -nodes -days 3650 -newkey rsa: 2048 \
  - subj /CN=localhost /CN=localhost \
  - keyout files/nginx.key -out files/nginx.crt



##variabelen
we hebben de mogelijkheid om variabelen te gebruiken in onze playbooks. wanneer we variabelen definiëren zetten we dit onder de become stement in ons playbook. De syntax is als volgt:

vars:  
  key_file: /etc/nginx/ssl/nginx.key  
  cert_file: /etc/nginx/ssl/nginx.crt  
  conf_file: /etc/nginx/sites-available/default  
  server_name: localhost

je spreekt variabelen aan met dubbele brackets 


##handlers

