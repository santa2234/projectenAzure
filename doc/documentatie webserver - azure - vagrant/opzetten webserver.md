## week 1 opzoekwerk
### benodigdheden software initieël

	- updaten alles oftware
	- epel-release
	- nginx

### opzetten services

aanzetten van:
	- firewalld
	- nginx (ook nginx enablen om start op reboot te verkrijgen)


### firewall rules toevoegen
	- http
	- https


### testcommando's om nginx te testen

$ sudo nginx -T


### meerdere websites hosten

doen we met Server blocks die we specifieren in /etc/nginx/conf.d

## week 2 opzetten vagrant omgeving
We hebben terug een poging gedaan en bijna de fout van vorig jaar gemaakt. Ik begon terug alles zelf te schrijven en mij te verdiepen in vagrant maar heb dan beslist het roer om te gooien en gebruik te maken van de rescources die beschikbaar zijn.

### notities 
# listen [::]:80 default_server;
deze line hebben we uit gecommend maar we zien geen verandering.

## week 3

## gebruik code bert
Ik heb de ansible skeletton gecloned die toegang geeft om ansible roles te gebruiken in combinatie met vagrant aan de hand van site.yml. Hierna heb ik Bert zijn rol van httpd gecloned waarmee de basisconfiguratie van apache tot stand is gebracht.

## gedownloade rol ansible galaxy

We hebben de rol gebruikt van 

## problemen postgresql
Success. You can now start the database server using:

    /usr/bin/pg_ctl -D /var/lib/pgsql/data -l logfile start

wanneer we dit commando uitvoeren:
2020-10-19 10:07:49.607 UTC [8244] FATAL:  lock file "postmaster.pid" already exists

	-> normaliter opgelost door created optie (aanbeveling van bert). Gaat enkel uitvoeren wanneer /var/lib/data nog niet bestaat dit is waar de postgresql data zal zitten


## kijken of postgresql draait
systemctl status postgresql


## week 4

problemen met postgresql
	- user die de service moet starten moet postgres zijn. We gaan nog kijken of we de permissies kunnen 
		veranderen voor aangepaste user.


## week 5

In deze week gaan we alle files droppen op de server beginnende met onze gemaakte configurationfile:

```bash
server {
# hier stond vroeger default_server bij die zal omleiden naar /var/www/html
        listen 80;
        listen [::]:80;

        root /var/www/corona2002.local/html;
        index index.html index.htm index.nginx-debian.html;

        server_name corona2002.local www.corona2002.local;

        location / {
                try_files $uri $uri/ =404;
        }
}
```

We hebben ook de mappen aangemaakt voor de virtualhost configuration met toevoeging van default pagina dit allemaal met volgende ansible commands:

```yaml
- name: mappen maken virtual hosts sites available
  file:
    path: /etc/nginx/sites-available
    state: directory
    owner: santi
    group: wheel
    mode: 755

- name: mappen maken virtual hosts sites available
  file:
    path: /etc/nginx/sites-enabled
    state: directory
    owner: santi
    group: wheel
    mode: 755

  - name: overwrite config erop zetten
  template:
    src: files/corona2002.local
    dest: /etc/nginx/sites-available/
    owner: santi
    group: wheel
    mode: 755

- name: domeinMap maken
  file:
    path: /var/www/corona2020.local
    state: directory
    owner: santi
    group: wheel
    mode: 755

- name: HTML map maken in domeinmap
  file:
    path: /var/www/corona2002.local/html
    state: directory
    owner: santi
    group: wheel
    mode: 755

# onderstaand commando moet nog afgewerkt worden namelijk waar de lijn moet komen te staan
- name: lijn toevoegen aan de config file om virtualhost config toe te voegen
  lineinfile:
    dest: /etc/nginx/nginx.conf
    state: present
    line: 'include *.conf'
    owner: santi
    group: wheel
    mode: 755

# volgens mij is onderstaand niet op zijn juiste plaats maar moet dit in site
# enabled of site available


- name: zet default pagina klaar
  template:
    src: files/index.html
    dest: /var/www/html/corona2002.local/html/
    owner: santi
    group: wheel
    mode: 755

```

## dns hosts file aanpassen om te testen

Om DNS functionaliteit te simuleren gaan we gebruik maken van de /etc/hosts file zodat we vanop onze lokale machine kunnen surfen naar onze domeinnaam.


## sites-enabled & sites-availeble config toevoegen aan main config file



## kijken naar filmpje omdat er nog altijd iets mis is

https://www.youtube.com/watch?v=HYNq-HyntZQ&ab_channel=Stackacademy.tv


## SSL connectie in theorie

1) ssl map maken in /etc/nginx
2) een certificate maken 
```bash
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/example.key -out /etc/nginx/ssl/example.crt
```

## huidige configuratiefolder dit is een voorbeeld van ssl configuratie:
```bash

# For more information on configuration, see:
#   * Official English Documentation: http://nginx.org/en/docs/
#   * Official Russian Documentation: http://nginx.org/ru/docs/

user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;

events {}

http {

    server {
# hier stond vroeger default_server bij die zal omleiden naar /var/www/html
        listen 80;
        listen [::]:80;
        server_name corona2002.local www.corona2002.local;
# onderstaand is zodat alle request naar onze site op onze site komt
        return 301 https://$server_name$request_uri;

      listen 443 ssl;
       ssl_certificate /etc.nginx/ssl/example.crt
       ssl_certificate /etc/nginx/ssl/example.key

        root /var/www/corona2002.local/html;
        index index.html index.htm index.nginx-debian.html;


        location / {
                try_files $uri $uri/ =404;
        }
}
}
```

## gemaakte fout SSL

We lieten onze http en https allebei naar poort 80 gaan. We moesten blijkbaar 2 aparte server instances aanmaken in de configuration van nginx. Zodat ze allebei naar een andere poortnr gaan. Software of daemons kunnen blijkbaar altijd maar 1 instance op 1 poort draaien op hetzelfde moment.


## probleem permissies
In ansible zet ik altijd de permissies op 755 doch krijg ik nog steess forbidden en zet ik ze handmatig op 755. Dit werkt wel.
   blijkbaar moeten we 4 cijfers zetten anders weet ansible niet dat we in ansible aan het werken zijn.
## postgresql

Na installatie:

Postgresql maakt gebruik van rollen om client authenticatie/authorisatie te doen. 

Identauthentication= associeerd rollen met de matchende unix/linux accounts. Als een rol bestaan in postgres moet er ook een UNIX/LINUX username zijn met DEZELFDE NAAM om te kunnen inloggen.

###default role / account = postgres. 

commando's:

###inloggen in postgres:

```bash
sudo -i -u postgres
```

###in de postgres prompt gaan (met postgres acc):

```bash
psql
```

###inloggen postgresql
sudo -u postgres psql

### lijst users hun role attributen op


###exit uit postgresql:

\q

### logfiles pgsql
/var/log/php-fpm


