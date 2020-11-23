### azure basics

####inloggen:
``` 
az login
```

#### resource group maken voor machines in te zetten
```
az group create --name projectenTest --location westus
```

#### Virtuele machine aanmaken
(voor de imges moet je kijken met commando: az vm image list --output table)
```
az vm create --resource-group projectenTest \
--name charlie \
--image OpenLogic:CentOS:7.5:latest \
--generate-ssh-keys \
--output json \
--verbose
```
####info over vm te weten komen
```
az vm show --name charlie --resource-group projectenTest
```
```
az vm show --name charlie \
  --resource-group projectenTest \
  --query 'networkProfile.networkInterfaces[].id' \
  --output tsv
```
(de query is een dictionary die eindigd met een array vandaar de '[]' -notatie)
(we gebruiken deze --query zodat we het objectid kunnen te weten komen. Hierdoor kunnen we rechtstreeks informatie krijgen over de vm en zijn capabilities)

we kunnen deze variabele dan ook meteen in een environmental variabele steken:
```
NIC_ID=$(az vm show -n TutorialVM1 -g TutorialResources \
  --query 'networkProfile.networkInterfaces[].id' \
  -o tsv)
```


####informatie krijgen met verkregen object id

nu kunnen we rechtstreeks informatie krijgen over onze netwerkadapter zonder onze resource group of wat dan ook te moeten vernoemen.

```
az network nic show --ids $NIC_ID
```

commando met qurey om publiekIP en subnetid te weten te komen
```
az network nic show --ids $NIC_ID \
  --query '{IP:ipConfigurations[].publicIpAddress.id, Subnet:ipConfigurations[].subnet.id}' \
  -o json
```
we kunnen output die we verkrijgen over onze machine ook in variabele steken we moeten ze dan laten outputten in csv, en een delimiter kiezen die meteen na onze read -d komt hieronder een voorbeeld om de variabele ip_id en subnet_id in te vullen:
```
read -d '' IP_ID SUBNET_ID <<< $(az network nic show \
  --ids $NIC_ID \
  --query '[ipConfigurations[].publicIpAddress.id, ipConfigurations[].subnet.id]' \
  -o tsv)
```

om nu het ip ADRES te verkrijgen vanuit de ip_id doen we volgende:
```
VM1_IP_ADDR=$(az network public-ip show --ids $IP_ID \
  --query ipAddress \
  -o tsv)
```

bekijk het ip adres: 

```
echo $VM1_IP_ADDR
```