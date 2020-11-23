#ontleding playbook

1) - name
-> comment die zegt waar de play over gaat (eender wat), dit is ook optioneel en niet verplicht in een playbook.

2) become
-> wanneer deze waarde op True staat ga je root user worden bij elk commando
by default kan je dit niet zomaar aanzetten dat was misschien ons vorig probleem onthoud dat de vagrant user momenteel op root staat.

3) vars
-> een lijst van variabelen (zie later)

4) modules

-> modules zijn scripts die meekomen met ansible. Dit is om actie te verrichten op een host. voorbeelden van zulke acties zijn coommando's zoals:

yum

copy
-> kopiert een file can de lokale machine naar de host.

file
-> zet een attribuut van een file, symlink of directory

service

template
-> (genereert een file van een template en kopiërt dit naar de host)
met commando `ansible-doc modules`kan je informatie gaan opvragen over modules

Handlers
-> Handlers zijn een vorm van condities in ansible. Het doet ongeveer hetzelfde als een task maar gaat enkel starten wanneer hij ingelicht is door een task. Een task zal de handler gaan triggeren en ansible herkend dat de taak een state van het systeem heeft verandert.

een taks gaat een handler gaan verwittigen door de naam van die handler mee te geven als argument. dit doen we zo:

 - name: copy TLS key      
   copy: src=files/nginx.key dest={{ key_file }} owner=root mode=0600
   notify: restart nginx

   het is de notify die de handler gaat triggeren.


handlers: 
- name: restart nginx 
  service: name=nginx state=restarted

maar ook wanneer we zaken gaan kopieren in ansible moet dit blijkbaar omgeven zijn door handlers dit zullen we moeten testen.


# voorbeeld van playbook die shell commando's uitvoert op host
----------------------------------------------------------------------------------------------------------

- name: Execute the command in remote shell; stdout goes to the specified file on the remote.
  shell: somescript.sh >> somelog.txt

- name: Change the working directory to somedir/ before executing the command.
  shell: somescript.sh >> somelog.txt
  args:
    chdir: somedir/

# You can also use the 'args' form to provide the options.
- name: This command will change the working directory to somedir/ and will only run when somedir/somelog.txt doesn't exist.
  shell: somescript.sh >> somelog.txt
  args:
    chdir: somedir/
    creates: somelog.txt

# You can also use the 'cmd' parameter instead of free form format.
- name: This command will change the working directory to somedir/.
  shell:
    cmd: ls -l | grep log
    chdir: somedir/

- name: Run a command that uses non-posix shell-isms (in this example /bin/sh doesn't handle redirection and wildcards together but bash does)
  shell: cat < /tmp/*txt
  args:
    executable: /bin/bash

- name: Run a command using a templated variable (always use quote filter to avoid injection)
  shell: cat {{ myfile|quote }}

# You can use shell to run other executables to perform actions inline
- name: Run expect to wait for a successful PXE boot via out-of-band CIMC
  shell: |
    set timeout 300
    spawn ssh admin@{{ cimc_host }}

    expect "password:"
    send "{{ cimc_password }}\n"

    expect "\n{{ cimc_name }}"
    send "connect host\n"

    expect "pxeboot.n12"
    send "\n"

    exit 0
  args:
    executable: /usr/bin/expect
  delegate_to: localhost

# Disabling warnings
- name: Using curl to connect to a host via SOCKS proxy (unsupported in uri). Ordinarily this would throw a warning.
  shell: curl --socks5 localhost:9000 http://www.ansible.com
  args:


#PLAYBOOK EIGENSCHAP

tussen de ':' van een statement moet er altijd een spatie komen
dit was de fout waarom onze shell commando's er niet door kwamen

------------------------------------------------------------------------------------------------------------------------------
NGINX

onze dnsserver kan nog geen webserver worden omdat nginx nog iets nodig heeft nochtans is de test van nginx (nginx -t)
juist en geeft deze ons geen fouten hier moet nog verder naar gezocht worden. 

  -> we hebben ook een tekstbestand gemaakt waar de weggelaten yaml instaat die we terug in het playbook zullen moeten zetten maar moet aangepast worden.

 -> nadat we nginx gekilled hadden met `pkill httpd`