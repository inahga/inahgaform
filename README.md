# inahga.org Cloud Proxy

Configures the AWS-based HAProxy reverse proxy that sits in front of all servers. Also configures pfsense firewall port forwards.

### Deploy to AWS
Ensure you are logged into AWS under the correct region (`us-west-2`) with `aws configure`. Ensure Terraform is installed.
```
cd terraform/
terraform init
terraform apply
```

`inventory/terraform` will automatically be updated. Commit this file.

### Configure instances and firewall
Ensure Ansible is installed and you have the correct SSH key.
```
ansible-galaxy collection install -r requirements.yaml
ansible-playbook -i inventory cloud.yaml &
ansible-playbook -i inventory pfsense.yaml &
```
