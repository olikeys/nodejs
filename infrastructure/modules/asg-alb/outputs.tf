output "alb_zoneid" {
  value = "${aws_alb.default_alb.zone_id}"
}

output "alb_dnsname" {
    value = "${aws_alb.default_alb.dns_name}"
}