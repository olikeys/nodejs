// VPC variable
man_pvt_subnets = ["10.1.0.0/28", "10.1.0.16/28", "10.1.0.32/28"]
man_pub_subnets = ["10.2.1.48/28", "10.2.1.64/28", "10.2.1.80/28"]

app_pvt_subnets = ["10.2.0.0/28", "10.2.0.16/28", "10.2.0.32/28"]
app_pub_subnets = ["10.2.0.48/28", "10.2.0.64/28", "10.2.0.80/28"]

// Bastion variables
bastion_instance_type = "t2.micro"
bastion_ami = "ami-8fd760f6"
bastion_key_name = "bastion"
bastion_iam_role_config = {
  name                  = "bastion"
  force_detach_policies = "false"
  description           = "iam_role_for_bastion_ec2_instances"
}


// Application variables
application_instance_type = "t2.micro"
application_ami = "ami-8fd760f6"
application_key_name = "application"
application_iam_role_config = {
  name                  = "application"
  force_detach_policies = "false"
  description           = "iam_role_for_application_ec2_instances"
}

r53_zoneid = "Z278TU4O8BC3E6"
r53_name  = "cni-techtest-ok.com."
allowed_ip_ranges = "5.67.194.76/32"
