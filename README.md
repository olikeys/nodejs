# cni-techtest
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
    - add the following to your ~/.ssh/config
```
        Host 10.2.*.*
        ProxyCommand ssh -W %h:%p bastion
        User ubuntu

        Host bastion
        Hostname bastion.**your-domain.com**
        User ubuntu
        ForwardAgent yes
```
    - 

# Configuration instructions
    - create secrets.tfvars under projectdir/infrastructure with the following variables
        awsakey=**"your_aws_key"**
        awssecret=**"your_aws_secret"**
    - update the following variables within variables.tfvars
        r53_zoneid = **"your_existing_zoneid"**
        r53_name  = **"your-domain.com."**
        allowed_ip_ranges = **"your_IP_range"**

# Run
    - terraform init
    - terraform plan -var-file="variables.tfvars"
    - terraform apply -var-file="variables.tfvars"
