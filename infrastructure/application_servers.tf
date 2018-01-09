module "application_asg" {
    source              = "./modules/asg-alb"
    //ASG variables
    asg_name            = "application-autoscaling-group" 
    subnet_ids          = ["${aws_subnet.application_pub_subnet.*.id}"]
    min_size            = 3
    max_size            = 3
    tag_name            = "application-instance"
    tag_description     = "Application instance running Node.js and application"

    //ALB_TG Variables
    vpc_id              = "${aws_vpc.application_vpc.id}"
    alb_tg_name         = "application-alb-target-group"
    alb_https_port      = "${var.application_port}"
    lc_sec_group        = ["${aws_security_group.application_security_group.id}"]
    lc_key_name         = "${var.application_key_name}"
    lc_iam_profile      = "${module.application_iam_role.iam_instance_profile}"
    lc_it               = "${var.application_instance_type}"
    lc_image_id         = "${var.application_ami}"
    lc_name_prefix      = "application-launch-config-"
    associate_pub_ip    = true

    //ALB Variables
    alb_name                = "application-alb"
    load_balancer_http_port = "80"
    alb_sg_name             = "application-alb-sg"
    bastion_sg              =  ["${aws_security_group.bastion_security_group.id}"]
    alb_internal            = false
}

resource "aws_key_pair" "application" {
  key_name   = "application"
  public_key = "${file("${path.root}/keys/application.pub")}"
}

module "application_iam_role" {
  source             = "./modules/iam_role"
  config             = "${var.application_iam_role_config}"
  assume_role_policy = "${file("${path.root}/templates/assume_role_policy.json")}" 
  iam_role_policy    = "${file("${path.root}/templates/application_role_policy.json")}"
}

resource "aws_security_group" "application_security_group" {
  name        = "application-sg"
  description = "application security group"
  vpc_id      = "${aws_vpc.application_vpc.id}"

/*
  lifecycle {
    ignore_changes = ["ingress"] #to prevent rebuild when we manually add our home's public IP
  }
*/

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = ["${aws_security_group.bastion_security_group.id}"]
    self        = true
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = ["${aws_security_group.bastion_security_group.id}"]
    self        = true
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_route53_record" "www" {
  zone_id = "${var.r53_zoneid}"
  name    = "${var.r53_name}"
  type    = "A"
  
  alias {
    name                   = "dualstack.${module.application_asg.alb_dnsname}"
    zone_id                = "${module.application_asg.alb_zoneid}"
    evaluate_target_health = true
  }
}
