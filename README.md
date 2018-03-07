# Built using 
    - AWS
    - Terraform
    - Ansible
    - aws spec
    
# Install instructions
    - gem install awspec
    - awspec init
    - create 2 rsa keys named application and bastion server under projectdir/infrastructure/keys
    - add the newly created keys to the key manager
    - add the following to your ~/.ssh/config this will allow ssh to the application instances via the bastion host
```
        Host 10.2.*.*
        ProxyCommand ssh -W %h:%p bastion
        User ubuntu

        Host bastion
        Hostname bastion.**your-domain.com**
        User ubuntu
        ForwardAgent yes
```

# Configuration instructions
    - create secrets.tfvars under projectdir/infrastructure with the following variables
        awsakey=**"your_aws_key"**
        awssecret=**"your_aws_secret"**
    - update the following variables within variables.tfvars
        r53_zoneid = **"your_existing_zoneid"**
        r53_name  = **"your-domain.com."**
        allowed_ip_ranges = **"your_IP_range"**
    - Set following environment variables
        AWS_ACCESS_KEY_ID=**"your_aws_key"**
        AWS_SECRET_ACCESS_KEY=**"your_aws_secret"**
    - Update projectdir/configuration/group_vars/all.yml to include your domain name
        ansible_ssh_common_args: '-o ProxyCommand="ssh -o StrictHostKeyChecking=no -W %h:%p -q ubuntu@bastion.**your-domain.com"'

# Run
    - change to infrastructure directory under the project folder
    - terraform init
    - terraform plan -var-file="variables.tfvars" -var-file="secrets.tfvars"
    - terraform apply -var-file="variables.tfvars" -var-file="secrets.tfvars" -auto-approve
    - change to the configuration directory under the project folder
    - ansible-playbook -i inventory/ec2.py hello_world.yml
    - ansible-playbook -i inventory/ec2.py testing.yml
