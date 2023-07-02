#!/bin/bash

#1st VM Debian for Ansible
#This script must be executed after scriptWazuhVM.sh is executed on the remote server

#Install Ansible

#Install required dependencies
apt-get update
apt-get install lsb-release software-properties-common

#Setup ansible repository
echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" | sudo tee -a /etc/apt/sources.list.d/ansible-debian.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
apt-get update

#Install ansible
apt-get install ansible

#Ask for credentials
read -p 'Ip Address: ' your_ipaddr

#Generate an authentication key pair for SSH
ssh-keygen

#Permissions settings
chmod 700 ~/.ssh/

#Install openssh-server
apt-get install openssh-server

#Start SSH service
systemctl start sshd

#Send ssh key to the wazuh server
cat ~/.ssh/id_rsa.pub | ssh root@${your_ipaddr} "cat >> ~/.ssh/authorized_keys"

#Edit hosts file
python3 changeHosts.py

#Clone wazuh-ansible repository
sudo git clone --branch v4.4.4 https://github.com/wazuh/wazuh-ansible.git /etc/ansible/roles/

#Install Wazuh Indexer and Dashboard
cp wazuh-indexer-and-dashboard.yml /etc/ansible/roles/wazuh-ansible/playbooks/

#Run the playbook
ansible-playbook /etc/ansible/roles/wazuh-ansible/playbooks/wazuh-indexer-and-dashboard.yml -b -K

#Install wazuh manager

#We install it in all_in_one so we have to modify the host in the manager playbook
cp wazuh-manager-oss.yml /etc/ansible/roles/wazuh-ansible/playbooks/

#Run the playbook
ansible-playbook wazuh-manager-oss.yml -b -K
