<h1 align="center"> ⚠️ IMPORT NOTE: THE SOLUTION DOES NOT INCLUDE ROUTE53!</h1>
<h1 align="center">ALB DNS NAME WILL BE USED INSTEAD</h1>


# 1. Configure AWS & DB credentials
```bash
# ===== SETUP =====
# 1. Configure AWS & DB credentials
export AWS_ACCESS_KEY_ID="YOUR_ACCESS_KEY"
export AWS_SECRET_ACCESS_KEY="YOUR_SECRET_KEY"
```

# 2. Deploy infrastructure
Run from the project directory
```bash
./build_deploy.sh
```
Expect the prompt below, to continue with the deployment please type "yes"

```bash
        #This key is not known by any other names.
        #Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
        #Please type 'yes', 'no' or the fingerprint: yes
        #Please type 'yes', 'no' or the fingerprint: yes
        #ok: [ec2_primary]
        #YES
        #Please type 'yes', 'no' or the fingerprint: yes
        #ok: [ec2_secondary]

```

In case the ansible playbook triggers an error, stopping the script (most likely), please rerun the following command until it completes

```bash
cd ansible && ansible-playbook -i inventory.ini api_v2.yml
```

### Possible errors to be prompted:

```bash
 UNREACHABLE! => {"changed": false, "msg": "Failed to connect to the host via ssh: Shared connection to 10.16.6.91 closed.", "unreachable": true}
 UNREACHABLE! => {"changed": false, "msg": "Failed to connect to the host via ssh: ", "unreachable": true}
 UNREACHABLE! => {"changed": false, "msg": "Failed to connect to the host via ssh: Connection timed out during banner exchange\r\nConnection to UNKNOWN port 65535 timed out", "unreachable": true}
```
If it is the case please run the following command


##   TESTING  
Once the playbook is fully completed, run the following script to run the tests !
```bash
  ./app_tests.sh
```
<br><br>

---
   <h1 align="center">📋 BRIEF REPORT</h1>
<br>


## ✅ Improvements

### Terraform Infrastructure
- Restructured code into modules, improving consistency and collaboration capabilities
- Simplified maintenance through standart components

### AWS Key Management
- Migrated SSH key storage to AWS Systems Manager (SSM)
- Implemented secure parameter handling for keys
- Enhanced key generation 

### IAM & Networking
- Tightened IAM policies with least-privilege principles
- Integrated Route53 DNS with ALB endpoints

## ⚠️ Known Issues & Limitations

### Ansible Initialization
- **Issue:** First-time playbook runs occasionally fail due to ProxyJump/key authentication and connectivity problems
- for example:
```bash
 UNREACHABLE! => {"changed": false, "msg": "Failed to connect to the host via ssh: Shared connection to 10.16.6.91 closed.", "unreachable": true}
 UNREACHABLE! => {"changed": false, "msg": "Failed to connect to the host via ssh: ", "unreachable": true}
 UNREACHABLE! => {"changed": false, "msg": "Failed to connect to the host via ssh: Connection timed out during banner exchange\r\nConnection to UNKNOWN port 65535 timed out", "unreachable": true}
```
or warnings
```bash
[WARNING]: sftp transfer mechanism failed on [52.56.70.94]. Use ANSIBLE_DEBUG=1 to see detailed information

```
- **Impact:** Delays provisioning and due to inconsist errors difficults the troubleshoot.
- **Workaround:** Re-run playbook with verbose until is completed!!
- **Status:** Still investigating RCA

### Terraform Key Management
- **Issue:** Key regeneration during `terraform apply` replaces .pem files
- **Impact:** Loss of EC2 instance access after infrastructure updates


## 🚀 Future Work

### Domain & SSL Implementation
1. Register/transfer domain to Route53
2. Request ACM SSL certificate
3. Configure ALB to:
   - Redirect HTTPS (443) → HTTP (80)
   - Terminate TLS at load balancer
   - Maintain encrypted traffic to instances

### Ansible Optimization
- optimise playbooks and reusability
- improve first-run reliability
- add error handling

### Security Enhancements
- implement solution for key rotation
- establish SSH certificate 
- tight ALB security policies
- harden IAM policies and roles
