import sys
ipaddr = sys.argv[1]
agentName = sys.argv[2]
agent_playbook = '''- hosts: wazuh_agents
  become: yes
  become_user: root
  roles:
    - ../roles/wazuh/ansible-wazuh-agent
  vars:
    wazuh_managers:
      - address: {ipaddr}
        port: 1514
        protocol: tcp
        api_port: 55000
        api_proto: 'http'
        api_user: ansible
        max_retries: 5
        retry_interval: 5
    wazuh_agent_enrollment:
      enabled: ''
      manager_address: ''
      port: 1515
      agent_name: '{agentName}'
      groups: ''
      agent_address: ''
      ssl_cipher: HIGH:!ADH:!EXP:!MD5:!RC4:!3DES:!CAMELLIA:@STRENGTH
      server_ca_path: ''
      agent_certificate_path: ''
      agent_key_path: ''
      authorization_pass_path: /var/ossec/etc/authd.pass
      auto_method: 'no'
      delay_after_enrollment: 20
      use_source_ip: 'no'\''''.format(ipaddr = ipaddr, agentName = agentName)
f = open('/etc/ansible/roles/wazuh-ansible/playbooks/wazuh-agent.yml', 'w')
f.write(agent_playbook)
f.close()
