# DNS Test plan


## Validate config files:
### Check of the main config file is syntactically correct:  
> named-checkconf /etc/named.conf  

### Check of the forward zone file is syntactically correct:
> named-checkzone corona2020.local  /var/named/corona2020.local

### Check of the service is running:
> systemctl status named

## Query dns private servers:
>dig alfa.corona2020.local @192.0.2.1  
>dig bravo.corona2020.local @192.0.2.1  
>dig charlie.corona2020.local @192.0.2.1  
>dig delta.corona2020.local @192.0.2.1  

### Query dns server of corona2020.local:
> dig NS corona2020.local @192.0.2.1

### Query mail server of corona2020.local:
> dig MX corona2020.local @192.0.2.1

### Start-of-Authority section for corona2020.local:
> dig SOA corona2020.local @192.0.2.1

### Get any RR that contains:
> dig any corona2020.local @192.0.2.1


### Reverse lookups private servers:
>dig -x 192.0.2.1 @192.0.2.1  
>dig -x 192.0.2.2 @192.0.2.1  
>dig -x 192.0.2.3 @192.0.2.1  
>dig -x 192.0.2.4 @192.0.2.1  

### Alias lookups private servers:
>dig mail-in.corona2020.local  @192.0.2.1  
>dig dns.corona2020.local  @192.0.2.1  
>dig ns1.corona2020.local  @192.0.2.1  
>dig charlie.corona2020.local  @192.0.2.1   
>dig www.corona2020.local  @192.0.2.1   
>dig domain-controller.corona2020.local @192.0.2.1  


## Query dns public servers:
>dig www.hogent.be   
>dig www.hogent.be @8.8.8.8  

### Query dns server of hogent.be:
>dig NS hogent.be

### Query mail server of domain hogent.be:
>dig MX hogent.be

### Start-of-Authority section for hogent.be:
> dig SOA hogent.be

### Get any RR that contains:
>dig ANY hogent.be @ens1.hogent.be

### Reverse lookups public servers:
> dig -x 193.190.173.132 @ens1.hogent.be
