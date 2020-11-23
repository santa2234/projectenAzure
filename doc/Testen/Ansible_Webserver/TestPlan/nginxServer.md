###testplan nginx Webserver

#### basic ping test
ping 192.168.56.10

#### test op browser
1) surf naar http://192.168.56.10

    -> moet redirecten naar https://192.168.56.10
    -> moet een warning geven omdat dit self-assigned certificate is
    -> klik op "geavanceerd" en daarna "ga door"
    -> je krijgt nu een SSL verbinding die niet veilig is omdat het een self signed certificate is 

2) test info.php
    -> surf naar http://192.168.56.10/phpinfo.php
    -> de php pagina moet weergeven met opmaak zo weten we dat de php engine juist werkt


### test drupal applicatie

1) surf naar http://192.168.56.10
2) kies voor de taal "english" en ga naar volgende
3) select installation profile -> "standard"
4) scroll naar onder -> duidt continue anyway aan -> volgende stap
5) database configuration -> kies voor postgresql
    database name: drupal
    database username: santi
    database password: santi
6) installatieproces voltooid
7) vul gegevens in: siteadres = corona2002.local
                    site email = *te kiezen*
                    username = *te kiezen*
                    site email = *te kiezen*@corona2002.local
8) save and continue
9 installatie voltooid


