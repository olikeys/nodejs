provider "aws" {
    region = "eu-west-1"
}

data "aws_availability_zones" "all" {}

resource "aws_vpc" "application_vpc" {
    cidr_block              = "10.2.0.0/16"
    enable_dns_support      = true
    enable_dns_hostnames    = true
    
    tags {
        Name = "application-vpc"
    }
}

resource "aws_internet_gateway" "application_internet_gateway" {
    vpc_id = "${aws_vpc.application_vpc.id}"

    tags {
        Name = "application-vpc-internet-gateway"
    }
}

resource "aws_subnet" "management_pub_subnet" {
    count               = "${length(data.aws_availability_zones.all.names)}"
    vpc_id              = "${aws_vpc.application_vpc.id}"
    cidr_block          = "${var.man_pub_subnets[count.index]}"
    availability_zone   = "${data.aws_availability_zones.all.names[count.index]}"

    tags {
        Name = "man-pub-${data.aws_availability_zones.all.names[count.index]}"
    }
}

resource "aws_subnet" "application_pub_subnet" {
    count               = "${length(data.aws_availability_zones.all.names)}"
    vpc_id              = "${aws_vpc.application_vpc.id}"
    cidr_block          = "${var.app_pub_subnets[count.index]}"
    availability_zone   = "${data.aws_availability_zones.all.names[count.index]}"

    tags {
        Name = "app-pub-${data.aws_availability_zones.all.names[count.index]}"
    }
}

resource "aws_route_table" "management_pub_route" {
    count   = "${length(data.aws_availability_zones.all.names)}"
    vpc_id  = "${aws_vpc.application_vpc.id}"

  tags {
    Name = "management-public-subnets-route-table-${data.aws_availability_zones.all.names[count.index]}"
  }
}

resource "aws_route_table" "application_pub_route" {
    count   = "${length(data.aws_availability_zones.all.names)}"
    vpc_id  = "${aws_vpc.application_vpc.id}"

    tags {
        Name = "application-public-subnets-route-table-${data.aws_availability_zones.all.names[count.index]}"
    }
}

resource "aws_route_table_association" "management_public" {
    count          = "${length(data.aws_availability_zones.all.names)}"
    subnet_id      = "${element(aws_subnet.management_pub_subnet.*.id, count.index)}"
    route_table_id = "${element(aws_route_table.management_pub_route.*.id, count.index)}"
}

resource "aws_route_table_association" "application_public" {
    count          = "${length(data.aws_availability_zones.all.names)}"
    subnet_id      = "${element(aws_subnet.application_pub_subnet.*.id, count.index)}"
    route_table_id = "${element(aws_route_table.application_pub_route.*.id, count.index)}"
}

resource "aws_route" "man_public_internet_gateway" {
    count                  = "${length(data.aws_availability_zones.all.names)}"      
    route_table_id         = "${element(aws_route_table.management_pub_route.*.id, count.index)}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = "${aws_internet_gateway.application_internet_gateway.id}"
}

resource "aws_route" "app_public_internet_gateway" {
    count                  = "${length(data.aws_availability_zones.all.names)}"      
    route_table_id         = "${element(aws_route_table.application_pub_route.*.id, count.index)}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = "${aws_internet_gateway.application_internet_gateway.id}"
}

/*
resource "aws_route53_zone" "primary" {
  name = "cni-techtest-ok.com"
}
*/
