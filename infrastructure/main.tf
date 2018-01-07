provider "aws" {
    region = "eu-west-1"
}

data "aws_availability_zones" "all" {}
/*
resource "aws_vpc" "management_vpc" {
    cidr_block              = "10.1.0.0/16"
    enable_dns_support      = true
    enable_dns_hostnames    = true
    
    tags {
        Name = "managment-vpc"
    }
}
*/
resource "aws_vpc" "application_vpc" {
    cidr_block              = "10.2.0.0/16"
    enable_dns_support      = true
    enable_dns_hostnames    = true
    
    tags {
        Name = "application-vpc"
    }
}
/*
resource "aws_internet_gateway" "management_internet_gateway" {
    vpc_id = "${aws_vpc.management_vpc.id}"

    tags {
        Name = "management-vpc-internet-gateway"
  }
}
*/
resource "aws_internet_gateway" "application_internet_gateway" {
    vpc_id = "${aws_vpc.application_vpc.id}"

    tags {
        Name = "application-vpc-internet-gateway"
    }
}
/*
resource "aws_subnet" "management_pub_subnet" {
    count               = "${length(data.aws_availability_zones.all.names)}"
    vpc_id              = "${aws_vpc.management_vpc.id}"
    cidr_block          = "${var.man_pub_subnets[count.index]}"
    availability_zone   = "${data.aws_availability_zones.all.names[count.index]}"

    tags {
        Name = "man-pub-${data.aws_availability_zones.all.names[count.index]}"
    }
}
*/
resource "aws_subnet" "application_pub_subnet" {
    count               = "${length(data.aws_availability_zones.all.names)}"
    vpc_id              = "${aws_vpc.application_vpc.id}"
    cidr_block          = "${var.app_pub_subnets[count.index]}"
    availability_zone   = "${data.aws_availability_zones.all.names[count.index]}"

    tags {
        Name = "app-pub-${data.aws_availability_zones.all.names[count.index]}"
    }
}

resource "aws_subnet" "application_pvt_subnet" {
    count               = "${length(data.aws_availability_zones.all.names)}"
    vpc_id              = "${aws_vpc.application_vpc.id}"
    cidr_block          = "${var.app_pvt_subnets[count.index]}"
    availability_zone   = "${data.aws_availability_zones.all.names[count.index]}"

    tags {
        Name = "app-pvt-${data.aws_availability_zones.all.names[count.index]}"
    }
}
/*
resource "aws_route_table" "management_pub_route" {
    count   = "${length(data.aws_availability_zones.all.names)}"
    vpc_id  = "${aws_vpc.management_vpc.id}"

  tags {
    Name = "management-public-subnets-route-table-${data.aws_availability_zones.all.names[count.index]}"
  }
}
*/
resource "aws_route_table" "application_pub_route" {
    count   = "${length(data.aws_availability_zones.all.names)}"
    vpc_id  = "${aws_vpc.application_vpc.id}"

    tags {
        Name = "application-public-subnets-route-table-${data.aws_availability_zones.all.names[count.index]}"
    }
}

resource "aws_route_table" "application_pvt_route" {
    count   = "${length(data.aws_availability_zones.all.names)}"
    vpc_id  = "${aws_vpc.application_vpc.id}"

    tags {
        Name = "application-private-subnets-route-table-${data.aws_availability_zones.all.names[count.index]}"
    }
}
/*
resource "aws_route_table_association" "management_public" {
    count          = "${length(data.aws_availability_zones.all.names)}"
    subnet_id      = "${element(aws_subnet.management_pub_subnet.*.id, count.index)}"
    route_table_id = "${element(aws_route_table.management_pub_route.*.id, count.index)}"
}
*/
resource "aws_route_table_association" "application_public" {
    count          = "${length(data.aws_availability_zones.all.names)}"
    subnet_id      = "${element(aws_subnet.application_pub_subnet.*.id, count.index)}"
    route_table_id = "${element(aws_route_table.application_pub_route.*.id, count.index)}"
}
/*
resource "aws_route" "man_public_internet_gateway" {
    count                  = "${length(data.aws_availability_zones.all.names)}"      
    route_table_id         = "${element(aws_route_table.management_pub_route.*.id, count.index)}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = "${aws_internet_gateway.management_internet_gateway.id}"
}
*/
resource "aws_route" "app_public_internet_gateway" {
    count                  = "${length(data.aws_availability_zones.all.names)}"      
    route_table_id         = "${element(aws_route_table.application_pub_route.*.id, count.index)}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = "${aws_internet_gateway.application_internet_gateway.id}"
}

resource "aws_eip" "app_nat_eip" {
    count     = "${length(data.aws_availability_zones.all.names)}"
    vpc       = true
}

resource "aws_nat_gateway" "app_nat_gateway" {
    count          = "${length(data.aws_availability_zones.all.names)}"
    allocation_id  = "${element(aws_eip.app_nat_eip.*.id, count.index)}"
    subnet_id      = "${element(aws_subnet.application_pub_subnet.*.id, count.index)}"

    depends_on     = ["aws_internet_gateway.application_internet_gateway"]
}

resource "aws_route" "app_nat_route" {
    count                  = "${length(data.aws_availability_zones.all.names)}"
    route_table_id         = "${element(aws_route_table.application_pvt_route.*.id, count.index)}"
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id         = "${element(aws_nat_gateway.app_nat_gateway.*.id, count.index)}"
}
/*
resource "aws_vpc_peering_connection" "man_to_app_peering" {
    peer_vpc_id   = "${aws_vpc.application_vpc.id}"
    vpc_id        = "${aws_vpc.management_vpc.id}"
    auto_accept   = true

    tags {
        Name = "VPC Peering connection between Management and Application VPCs"
    }
}

resource "aws_route" "application_vpc_peering_route" {
  count                     = "${length(data.aws_availability_zones.all.names)}"
  route_table_id            = "${element(aws_route_table.management_pub_route.*.id, count.index)}"
  destination_cidr_block    = "10.2.0.0/16" 
  vpc_peering_connection_id = "${aws_vpc_peering_connection.man_to_app_peering.id}" 
}
*/