resource "aws_autoscaling_group" "default_asg" {
  name                 = "${var.asg_name}"
  availability_zones   = ["${var.availability_zones}"]
  max_size             = "${var.max_size}"
  min_size             = "${var.max_size}"
  vpc_zone_identifier  = ["${var.subnet_ids}"]
  launch_configuration = "${aws_launch_configuration.default_launch_configuration.name}"
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