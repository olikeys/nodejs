# cni-techtest
# Built using 
    - AWS
    - Terraform (v0.11.1)
    - Ansible
    - aws spec
    

# Install instructions
    - Download Terraform from https://www.terraform.io/downloads.html and extract to your directory of choice, adding the location to your path statement if necessary
    - pip install boto

# Configuration instructions
    - AWS access and secret keys stored in ~/.aws/credentials

# Run
    - terraform init
    - terraform plan -var-file="variables.tfvars"
    - terraform apply -var-file="variables.tfvars"
