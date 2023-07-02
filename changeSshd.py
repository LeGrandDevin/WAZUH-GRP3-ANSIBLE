sshd_config = "PubkeyAuthentication yes\nAuthorizedKeysFile .ssh/authorized_keys"
f = open('/etc/ssh/sshd_config', 'a')
f.write(sshd_config)
f.close()
