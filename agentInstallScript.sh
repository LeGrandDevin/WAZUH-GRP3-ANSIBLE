read -p 'Agent IP Address: ' agent_ipaddr

#Send ssh key to the wazuh server
cat ~/.ssh/id_rsa.pub | ssh root@${agent_ipaddr} "cat >> ~/.ssh/authorized_keys"

#Create and configure agent playbook
python3 playbookAgent.py $agent_ipaddr

#Run the playbook
ansible-playbook /etc/ansible/roles/wazuh-ansible/playbooks/wazuh-agent.yml -b -K
