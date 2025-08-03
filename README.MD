# FastAPI AWS Deployment (Terraform + Ansible)

IMPORT NOTE:
THE SOLUTION DOES NOT INCLUDE ROUTE53! "ALB DNS NAME" SHOULD BE USE AS EXTERNAL ACCESS!

```bash
# ===== SETUP =====
# 1. Configure AWS & DB credentials
export AWS_ACCESS_KEY_ID="YOUR_ACCESS_KEY"
export AWS_SECRET_ACCESS_KEY="YOUR_SECRET_KEY"
export TF_VAR_db_password="your_db_password"

# 2. Deploy infrastructure
terraform init && terraform apply -auto-approve

# ===== IM STILL WORKING ON THE .SSH/KNOWN_HOSTS FILE TO IMPLEMENT BY ANSIBLE =====
ssh -i "./keys/bastion-key-pair.pem" ec2-user@"BASTION_PUBLIC_IP"
exit

# 3. Configure app via Ansible
cd ansible && ansible-playbook -i inventory.ini api_v2.yml
echo -e "\nIf the playbook fails due to connection issues with the instances, re-run it using:\n\n  cd ansible && ansible-playbook -i inventory.ini api_v2.yml\n\nWhen prompted, type 'yes'.\n"
# EXPECTED OUTPUT STILL WORKING ON THE .SSH/KNOWN_HOSTS

        #ansible-playbook -i inventory.ini api_v2.yml
        #TASK [Gathering Facts] 
        #***********************************************************************************************************************************************************************************
        #The authenticity of host '10.16.6.75 (<no hostip for proxy command>)' can't be established.
        #ED25519 key fingerprint is SHA256:yjLS/EKd7Mvs0W5VurZaMIj4tTNSU5LhZxLPSZR1sc4.
        #This key is not known by any other names.
        #The authenticity of host '10.16.5.249 (<no hostip for proxy command>)' can't be established.
        #ED25519 key fingerprint is SHA256:xCPmuw3XifiJ23ij2ClDqrfqoTRZEfEFyts0oAo3694.
        #This key is not known by any other names.
        #Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
        #Please type 'yes', 'no' or the fingerprint: yes
        #Please type 'yes', 'no' or the fingerprint: yes
        #ok: [ec2_primary]
        #YES
        #Please type 'yes', 'no' or the fingerprint: yes
        #ok: [ec2_secondary]



# ===== TESTING =====
# Get ALB endpoint (no Route53 configured) from AWS outputs
./app_tests.sh

# ===== CLEANUP =====
# Destroy all resources
cd .. && terraform destroy -auto-approve