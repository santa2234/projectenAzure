Looking up 127.0.0.1 first
Looking up 127.0.0.1
Making HTTP connection to 127.0.0.1
Sending HTTP request.
HTTP request sent; waiting for response.
Retrying as HTTP0 request.
Looking up 127.0.0.1
Making HTTP connection to 127.0.0.1
Sending HTTP request.
HTTP request sent; waiting for response.
Alert!: Unexpected network read error; connection aborted.
Can't Access `http://127.0.0.1/'
Alert!: Unable to access document.

lynx: Can't access startfil


## overgang naar centos 8

We zagen dat we toch de base box niet hadden aangepast we passen de box aan en verwijderen configuraties die vasthingen aan centos 7 die niet noodzakelijk zijn.

## installing lynx for testing purposes
Lynx is niet meer aanwezig bij centos 8 we hebben toch een manier om het te installeren:
dnf config-manager --set-enabled PowerTools
en nu kan het weer
yum install lynx

## probleem configuration file in template

Listen 443 ssl;
In onze gedownloade rol zit het ssl keyword er niet bij indien problemen zullen we dit moeten aanpassen.