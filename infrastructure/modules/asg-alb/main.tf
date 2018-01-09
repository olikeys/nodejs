resource "aws_autoscaling_group" "default_asg" {
  name                 = "${var.asg_name}"
  max_size             = "${var.max_size}"
  min_size             = "${var.max_size}"
  vpc_zone_identifier  = ["${var.subnet_ids}"]
  launch_configuration = "${aws_launch_configuration.default_launch_configuration.name}"
  target_group_arns    = ["${aws_alb_target_group.default_alb_tg.arn}"]
  health_check_type    = "${var.healthcheck}"
  enabled_metrics      = ["GroupInServiceInstances", "GroupTerminatingInstances"]
  tag {
    key                 = "Name"
    value               = "${var.tag_name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Description"
    value               = "${var.tag_description}"
    propagate_at_launch = true
  }
}


resource "aws_alb_target_group" "default_alb_tg" {
    name                = "${var.alb_tg_name}"
    port                = "${var.alb_https_port}"
    protocol            = "HTTP"
    vpc_id              = "${var.vpc_id}"
    health_check {
       path             = "/elb-status" //this might need to be a variable at some point
       protocol         = "HTTP"        //and this
       matcher          = "200"          //and this too
    }

}

resource "aws_launch_configuration" "default_launch_configuration" {
  name_prefix                   = "${var.lc_name_prefix}"
  image_id                      = "${var.lc_image_id}"
  instance_type                 = "${var.lc_it}"
  iam_instance_profile          = "${var.lc_iam_profile}"
  key_name                      = "${var.lc_key_name}"
  security_groups               = ["${var.lc_sec_group}"]
  associate_public_ip_address   = "${var.associate_pub_ip}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "default_load_balancer_sg" {
     name = "${var.alb_sg_name}"
     description = "Allow access to application load balancer"
     vpc_id = "${var.vpc_id}"

     ingress {
        from_port   = "${var.load_balancer_http_port}"
        to_port     = "${var.load_balancer_http_port}"
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        security_groups = ["${var.bastion_sg}"]
     }

     egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
     }
}

resource "aws_alb" "default_alb" {
    name                = "${var.alb_name}"
    internal            = "${var.alb_internal}"
    security_groups     = ["${aws_security_group.default_load_balancer_sg.id}"]
    subnets             = ["${var.subnet_ids}"]
}

resource "aws_alb_listener" "default_load_balancer_listener" {
    load_balancer_arn   = "${aws_alb.default_alb.arn}"
    port                = "${var.load_balancer_http_port}"
    protocol            = "HTTP"
    
    default_action {
       target_group_arn = "${aws_alb_target_group.default_alb_tg.arn}"
       type             = "forward"
    }
}