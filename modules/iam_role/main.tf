resource "aws_iam_role" "default" {
  name                  = "${var.config["name"]}"
  force_detach_policies = "${var.config["force_detach_policies"]}"
  description           = "${var.config["description"]}"
  assume_role_policy    = "${var.assume_role_policy}"
}

resource "aws_iam_role_policy" "default" {
  name                  = "${var.config["name"]}"
  role                  = "${aws_iam_role.default.id}"
  policy                = "${var.iam_role_policy}"
}

resource "aws_iam_instance_profile" "default" {
  name                  = "${var.config["name"]}"
  role                  = "${aws_iam_role.default.name}" 
}
