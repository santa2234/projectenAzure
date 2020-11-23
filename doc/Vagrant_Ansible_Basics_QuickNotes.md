# Vagrant basics

## Setting up a vagrantbox

$ vagrant init generic/centos8
-> installs a box to the current directory (creates a basic vagrantfile)

$ vagrant box add generic/centos8
-> makes a clone of a base system image (speeds up launching and provisioning)
-> stores the box locally!

$ vagrant box list
-> shows all the boxes

$ vagrant box remove generic/centos8
-> remove a box

$ vagrant status
-> current state of vagrant environment

## provisioning

##### bootstrap.sh

You can edit the bootstrap file to add applications to an OS.
- Edit the vagrantfile: config.vm.provision :shell, path: "bootstrap.sh"


## Connecting and starting a vagrantbox

$ vagrant up
-> starts up the VM

$ vagrant ssh
-> starts up an ssh connection to the vm (ctrl + D or exit to exit the session)

$vagrant destroy
-> stops the vm from running


https://sysadmincasts.com/episodes/42-crash-course-on-vagrant-revised
https://phoenixnap.com/kb/vagrant-beginner-tutorial
https://www.digitalocean.com/community/tutorials/how-to-install-the-apache-web-server-on-centos-7#step-1-%E2%80%94-installing-apache
Ansible: https://docs.ansible.com/ansible/latest/index.html


# Mailserver
https://www.youtube.com/watch?v=HPV1hJsRud0
https://www.youtube.com/watch?v=TJdaLudvCMA
https://www.youtube.com/watch?v=iPtmDXlRR84

## Summary vids
DNS:
Ip:
MX: ...com

First:
Server hostname in /etc/hostname
=> ...

Second
/etc/hosts
=> add ip to it with hostname (full address)
ip	address		hostname

TEST:
hostname
hostname -f (full address should be shown)
ifconfig


Thirds
apt-get update
apt-get upgrade
yum install postfix (looked up correct command)

Fourth
systemctl start postfix OR systemctl enable postfix

Fifth: Firewall
firewall -cmd --permanent --add-service=smtp

sixth:
vim /etc/postfix/main.cf
=> myhostname =...
=> mydomain =...
=> myorigin =$mydomain
=> inet_interfaces = all
=> mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain

Seventh:
systemctl restart postfix

# Troubleshooting/testing:
- systemctl status postfix
- journalctl -xn
- postconf -n (shows full configuration)
---------------------------------------
- mail -S "hai" user1@domain.com
- subject: testing
- content of mail
- . (to end the mail)
- su - user1 (goes to said user)
- mail (shows you the mail)
---------------------------------------
- vim /var/mail/user1 => see the mail of the user


## Extra
Mariadb on centOS 8
https://www.youtube.com/watch?v=jmN11nhjM_g
