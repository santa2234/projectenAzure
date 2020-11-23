### wat al gebeurt moet zijn 
er moet al een resource group aangemaakt zijn en een machine moet aanwezig zijn
de git repo moet gelinkt zijn in azure zodat onze roles beschikbaar zijn.

### ssh as service implementeren
1) ga naar de devops pagina van azure
2) maak een project aan
3) in dit project kies voor settings en klik op add a service connection
4) kies voor ssh
5) maak hem aan

### azure continuous integration pipeline aanmaken
1) ga naar pipelines
2) maak één aan
3) kies voor add with custom file without yaml
4) kies voor start with empty project

### je komt nu in een nieuwe omgeving met een agent
1) klik op de + van de agent we gaan hem een taak laten uitvoeren
2) je ziet rechts popup met namen van programma's waar hij taken mee kan uitvoeren
3) tik in de zoekbalk ansible
4) voeg deze toe 
5) klik hierop je ziet nu terug een pop up scherm, hier zal je jouw ssh as service moeten aanduiden en de files die je meewilt (playbooks) moeten meesturen.