module "bastion_asg" {
    source              = "./modules/asg-no-lb"
    //ASG variables
    asg_name            = "bastion-autoscaling-group" 
    subnet_ids          = ["${aws_subnet.management_pub_subnet.*.id}"]
    min_size            = 3
    max_size            = 3
    tag_name            = "bastion-instance"
    tag_description     = "Bastion instance for ssh access to application instances"
    vpc_id              = "${aws_vpc.application_vpc.id}"
    lc_sec_group        = ["${aws_security_group.bastion_security_group.id}"]
    lc_key_name         = "${var.bastion_key_name}"
    lc_iam_profile      = "${module.bastion_iam_role.iam_instance_profile}"
    lc_it               = "${var.bastion_instance_type}"
    lc_image_id         = "${var.bastion_ami}"
    lc_name_prefix      = "bastion-launch-config-"
    associate_pub_ip    = true
}

module "bastion_iam_role" {
  source             = "./modules/iam_role"
  config             = "${var.bastion_iam_role_config}"
  assume_role_policy = "${file("${path.root}/templates/assume_role_policy.json")}" 
  iam_role_policy    = "${file("${path.root}/templates/bastion_role_policy.json")}"
}

resource "aws_security_group" "bastion_security_group" {
  name        = "bastion-sg"
  description = "bastion security group"
  vpc_id      = "${aws_vpc.application_vpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.allowed_ip_ranges}"]
    self        = true
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.allowed_ip_ranges}"]
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}