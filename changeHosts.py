import sys
ipaddr = sys.argv[1]
hosts_config = "[all_in_one]\n{} ansible_ssh_user=root".format(ipaddr)
f = open('/etc/ansible/hosts', 'a')
f.write(hosts_config)
f.close()
