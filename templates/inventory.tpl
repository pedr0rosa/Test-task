
[all:vars]
ansible_user=ec2-user
ansible_python_interpreter=/usr/bin/python3

[bastion]
bastion_host ansible_host=${bastion_ip}

[bastion:vars]
ansible_connection=ssh
ansible_ssh_private_key_file=./../keys/bastion-key-pair.pem
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'

[private_instances]
#Private key file used by SSH. Useful if using multiple keys and you do not want to use SSH agent.
ec2_primary ansible_host=${ec2_primary} ansible_ssh_private_key_file=./../keys/ec2-key1-pair.pem
ec2_secondary ansible_host=${ec2_secondary} ansible_ssh_private_key_file=./../keys/ec2-key2-pair.pem


[private_instances:vars]
ansible_connection=ssh
#https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#assigning-a-variable-to-one-machine-host-variables
#o configure a ProxyCommand for a certain host (or group).
ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p -q ec2-user@${bastion_ip} -i ./../keys/bastion-key-pair.pem" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
ansible_ssh_extra_args='-o ForwardAgent=yes'
