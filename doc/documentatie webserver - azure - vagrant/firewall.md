## firewall commando's
  33  systemctl status firewalld
   34  service nginx configtest
   35  systemctl nginx configtest
   36  systemctl status nginx
   37  nginx -y
   38  nginx -t
   39  systemctl status nginx
   40  firewall-cmd --list-all
   41  firewall-cmd --add-port 80/tcp
   42  firewall-cmd --reload
   43  firewall-cmd --list-all
   44  systemctl restart firewalld
   45  firewall-cmd --list-all
   46  firewall-cmd --add-service http
   47  firewall-cmd --add-service nginx
   48  firewall-cmd --list-all
   49  systemctl restart firewalld
   50  firewall-cmd --list-all
   51  firewall-cmd --add-service nginx
   52  firewall-cmd --add-service http
   53  systemctl reload firewalld
   54  firewall-cmd --list-all
   55  history


## firewall reset bij reload en bij herstart
oplos:
Volgens mij zijn we het --permanent keyword vergeten in het commando we gaan dit nu testen. . . 

    -> dit was inderdaad het probleem.

We voegen nu poortnr's toe 80 en 443 aangezien deze worden gebruikt door nginx je kan dit zien in file: /etc/nginx/conf.d/conf

   62  firewall-cmd --add-service http --permanent
   63  firewall-cmd --add-service http --permanent
   64  firewall -cmd --add-port 80/tcp
   65  firewall-cmd --add-port 80/tcp --permanent
   66  firewall-cmd --add-port 443/tcp --permanent
   67  systemctl restart firewalld
   68  firewall-cmd --list-all

