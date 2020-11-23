### azure
Na het account te maken en een eerste blik op de gui van azure gaan we op zoek naar manieren om onze machine te deployen.

### deployment in stappen

1) resource group maken 
    is een logische groep van resources. "Container met verwante resources voor een azure oplossing"

2) valideer en creër de resource group (op create || validate klikken)
    - indien niet meteen resultaat dan refreshen.
    - (best naam "projecten" geven ofzo)

3) resource options kiezen
    - kiezen voor virtual machine
    - opties invullen
    - authenticatietype bespreken welke we kiezen. (ssh of passwoord wss ssh kiezen)



#### azure cli downloaden en installeren

1) we downloaden azure cli

2) we tikken "az login" waarna onze browser opent en ons inlogt waarna de terminal bevestiging geeft.

3) resource group maken in de cli met cmd:
az group create --name projectenTest --location westeurope

4) 


#### azure plugin installeren
1) azure plugin installeren vagrant: 
nodig om met vagrant en azure te communiceren:
vagrant plugin install vagrant-azure

2) installeer active directory application met access naar azure resource manager voor jouw subscriptie (vagrant kan nu communiceren met active directory azure . . . denk ik):

az ad sp create-for-rbac

3) dummybox azure installeren
vagrant box add azure https://github.com/azure/vagrant-azure/raw/v2.0/dummy.box --provider azure

3) vagrantfile klaarmaken voor azure:

vagrantfile toevoeging vanaf windows host:

Vagrant.configure('2') do |config|
  config.vm.box = 'azure'

  config.vm.provider :azure do |azure, override|

    # each of the below values will default to use the env vars named as below if not specified explicitly
    azure.tenant_id = ENV['AZURE_TENANT_ID']
    azure.client_id = ENV['AZURE_CLIENT_ID']
    azure.client_secret = ENV['AZURE_CLIENT_SECRET']
    azure.subscription_id = ENV['AZURE_SUBSCRIPTION_ID']

    azure.vm_image_urn = 'MicrosoftSQLServer:SQL2016-WS2012R2:Express:latest'
    azure.instance_ready_timeout = 600
    azure.vm_password = 'TopSecretPassw0rd'
    azure.admin_username = "OctoAdmin"
    override.winrm.transport = :ssl
    override.winrm.port = 5986
    override.winrm.ssl_peer_verification = false # must be false if using a self signed cert
  end

end


vagrantfile toevoeging vanaf linux host (weet niet of we deze gaan nodig hebben):

Vagrant.configure('2') do |config|
  config.vm.box = 'azure'

  # use local ssh key to connect to remote vagrant box
  config.ssh.private_key_path = '~/.ssh/id_rsa'
  config.vm.provider :azure do |azure, override|

    # each of the below values will default to use the env vars named as below if not specified explicitly
    azure.tenant_id = ENV['AZURE_TENANT_ID']
    azure.client_id = ENV['AZURE_CLIENT_ID']
    azure.client_secret = ENV['AZURE_CLIENT_SECRET']
    azure.subscription_id = ENV['AZURE_SUBSCRIPTION_ID']
  end

end

## parameters invullen in toegevoegd deel vagrantfile:
bij de installatie van active directory rol krijg je parameters deze moet je invullen in de vagrantfile toevoeging



### azure basic cmd's
##### azure basic credentials request

1) check azure login specs:
az account list

2) show subscription id (commando werkt enkel in powershell)
az account list --query '[?isDefault].id' -o tsv

3) azure image url's bekijken
az vm image list --output table