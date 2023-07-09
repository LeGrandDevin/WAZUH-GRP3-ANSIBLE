#!/bin/bash

#1st VM Debian for Ansible
#This script must be executed after scriptWazuhVM.sh is executed on the remote server

#Install Ansible

#Install required dependencies
apt-get update
apt install lsb-release software-properties-common

#Setup ansible repository
echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" | sudo tee -a /etc/apt/sources.list.d/ansible-debian.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
apt-get update

#Install ansible
apt install ansible

#Ask for credentials
read -p 'Remote system IP Address: ' manager_ipaddr
read -p 'Agent IP Address: ' agent_ipaddr

#Generate an authentication key pair for SSH
ssh-keygen

#Permissions settings
chmod 700 ~/.ssh/

#Send ssh key to the wazuh server
cat ~/.ssh/id_rsa.pub | ssh root@${manager_ipaddr} "cat >> ~/.ssh/authorized_keys"

#Clone wazuh-ansible repository
sudo git clone --branch v4.4.4 https://github.com/wazuh/wazuh-ansible.git /etc/ansible/roles/wazuh-ansible

#create hosts file if not exist
touch /etc/ansible/hosts

#Edit hosts file
python3 changeHosts.py $manager_ipaddr

#Install Wazuh Indexer and Dashboard
cp wazuh-indexer-and-dashboard.yml /etc/ansible/roles/wazuh-ansible/playbooks/

#Run the playbook
ansible-playbook /etc/ansible/roles/wazuh-ansible/playbooks/wazuh-indexer-and-dashboard.yml -b -K

#Install wazuh manager

#We install it in all_in_one so we have to modify the host in the manager playbook
cp wazuh-manager-oss.yml /etc/ansible/roles/wazuh-ansible/playbooks/

#Run the playbook
ansible-playbook /etc/ansible/roles/wazuh-ansible/playbooks/wazuh-manager-oss.yml -b -K
