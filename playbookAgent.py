import sys
ipaddr = sys.argv[1]
agent_playbook = '''- hosts: wazuh-agents
  become: yes
  become_user: root
  roles:
    - ../roles/wazuh/ansible-wazuh-agent
  vars:
    wazuh_managers:
      - address: {}
        port: 1514
        protocol: tcp
        api_port: 55000
        api_proto: 'http'
        api_user: ansible
        max_retries: 5
        retry_interval: 5'''.format(ipaddr)
f = open('/etc/ansible/roles/wazuh-ansible/playbooks/wazuh-agent.yml', 'w')
f.write(agent_playbook)
f.close()
