ipaddr = input("Entrez l'adresse ip du remote system: ")
hosts_config = "[all_in_one]\n{} ansible_ssh_user=root".format(ipaddr)
f = open('/etc/ansible/hosts', 'a')
f.write(hosts_config)
f.close()
print(hosts_config)