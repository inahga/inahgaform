# inahga.org Cloud Proxy

Configures the AWS-based HAProxy reverse proxy that sits in front of all servers. Also configures pfsense firewall port forwards.

## Deploy to AWS
Ensure you are logged into AWS under the correct region (`us-west-2`) with `aws configure`. Ensure Terraform is installed.
```
cd terraform/
terraform init
terraform apply
```

`inventory/terraform` will automatically be updated if the AWS instance is recreated. Commit this file.

## Configure instances and firewall
After deploying a new node, wait about 5 minutes for AWS provisioning to complete. Ensure Ansible is installed and you have the correct SSH key.
```
ansible-galaxy collection install -r requirements.yaml
ansible-playbook -i inventory cloud.yaml &
ansible-playbook -i inventory pfsense.yaml &
```

## Tasks
- Scale up cloud instances
    - Increase `aws_node_count` in `terraform/variables.tf`.
    - Deploy with Terraform and configure with Ansible.
- Add a new service
    - Modify HAProxy under `haproxy_cloud.cfg.j2` to configure the proxy.
    - Add alias and port forward to `variables.yaml` to configure the firewall.
    - Add port to `aws_ingress_service_allowlist` in `terraform/variables.tf` to configure the AWS NACL.
    - Add a CNAME to `cnames` in `terraform/variables.tf` for name resolution (if an HTTP service).
    - Deploy with Terraform and configure with Ansible.

## Todo
- Configure rsyslog to point to a nicer interface
- Monitor, test, and tweak abuse protection
- Find secure way to access HAProxy stats
