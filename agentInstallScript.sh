#Ask for credentials
read -p 'Remote-system/Manager IP Address: ' manager_ipaddr
read -p 'Agent IP Address: ' agent_ipaddr
read -p 'Agent name: ' agent_name

#Send ssh key to the wazuh server
cat ~/.ssh/id_rsa.pub | ssh root@${agent_ipaddr} "cat >> ~/.ssh/authorized_keys"

#Add role to hosts file
python3 changeHosts.py $agent_ipaddr "[wazuh_agents]"

#Create and configure agent playbook
python3 playbookAgent.py $manager_ipaddr $agent_name

#Run the playbook
ansible-playbook /etc/ansible/roles/wazuh-ansible/playbooks/wazuh-agent.yml -b -K
