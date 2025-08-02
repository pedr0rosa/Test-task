#!/bin/bash
cd infrastructure && 
terraform init && terraform apply -auto-approve && cd ..

# Run Ansible
pwd
cd ansible
ansible-playbook -i inventory.ini api_v2.yml