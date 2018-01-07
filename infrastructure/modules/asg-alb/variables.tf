variable "subnet_ids" {
  type = "list"
}

variable "availability_zones" {
    type = "list"
}

variable "vpc_id" {}
variable "asg_name" {}
variable "alb_tg_name" {}
variable "alb_https_port" {}
variable "lc_sec_group" {
    type = "list"
}
variable "lc_key_name" {}
variable "lc_iam_profile" {}
variable "lc_it" {}
variable "lc_image_id" {}
variable "lc_name_prefix" {}

variable "healthcheck" {
    default = "EC2"
}
variable "min_size" {
    default = 3
}
variable "max_size" {
    default = 3
}

variable "tag_name" {}
variable "tag_description" {}

variable alb_name {}
variable load_balancer_http_port {}

variable bastion_sg {}
