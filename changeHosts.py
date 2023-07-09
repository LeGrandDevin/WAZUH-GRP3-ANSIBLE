import sys
ipaddr = sys.argv[1]
rolename = sys.argv[2]
hosts_config = "\n{rolename}\n{ipaddr} ansible_ssh_user=root".format(rolename = rolename, ipaddr = ipaddr)
f = open('/etc/ansible/hosts', 'a')
f.write(hosts_config)
f.close()
