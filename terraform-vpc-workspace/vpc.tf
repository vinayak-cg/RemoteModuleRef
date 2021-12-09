resource "aws_vpc" "main_vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"

  tags {
    Name             = "${var.customer}_VPC_${var.ZONE}_${var.envr}"
    "OTAP Environment" = "${var.OTAP}"
    Application      = "${var.application}"
  }
}


##############################
# Application edge subnets  ##
##############################

resource "aws_subnet" "application" {
  vpc_id            = "${aws_vpc.main_vpc.id}"
  cidr_block        = "${element(var.ae_subnet_cidr, count.index)}"
  availability_zone = "${element(var.availability_zones, count.index)}"
  count             = "${length(var.ae_subnet_cidr)}"

  tags {
    Name             = "${var.customer}_SUBNET_${var.ZONE}_${var.envr}_AE_${element(var.availability_zones_tag, count.index)}"
    "OTAP Environment" = "${var.OTAP}"
    Application      = "${var.application}"
  }

  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "mod" {
  vpc_id = "${aws_vpc.main_vpc.id}"

  tags {
    Name             = "${var.customer}_IGW_${var.ZONE}_${var.envr}"
    "OTAP Environment" = "${var.OTAP}"
    Application      = "${var.application}"
  }
}

resource "aws_route_table" "application" {
  vpc_id = "${aws_vpc.main_vpc.id}"
  #count  = "${length(var.public_subnet_cidr)}"

  tags {
    Name             = "${var.customer}_ROUTE_${var.ZONE}_${var.envr}_AE"
    "OTAP Environment" = "${var.OTAP}"
    Application      = "${var.application}"
  }
}

resource "aws_route_table_association" "application" {
  count          = "${length(var.ae_subnet_cidr)}"
  subnet_id      = "${element(aws_subnet.application.*.id, count.index)}"
  route_table_id = "${aws_route_table.application.id}"
}

resource "aws_route" "application_internet_gateway" {
  count                  = "${length(var.ae_subnet_cidr)}"
  route_table_id         = "${aws_route_table.application.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.mod.id}"
}

resource "aws_route" "aepeering_route" {
  count                      = "${var.landingzone == "yes" ? 1 : 0}"
  route_table_id             = "${aws_route_table.application.id}"
  destination_cidr_block     = "${var.peeringdest}"
  vpc_peering_connection_id  = "${var.peeringid}"
}

#####################
# Frontend subnets  #
#####################

resource "aws_subnet" "public" {
  vpc_id            = "${aws_vpc.main_vpc.id}"
  cidr_block        = "${element(var.public_subnet_cidr, count.index)}"
  availability_zone = "${element(var.availability_zones, count.index)}"
  count             = "${length(var.public_subnet_cidr)}"

  tags {
    Name             = "${var.customer}_SUBNET_${var.ZONE}_${var.envr}_AF_${element(var.availability_zones_tag, count.index)}"
    "OTAP Environment" = "${var.OTAP}"
    Application      = "${var.application}"
  }

 # map_public_ip_on_launch = true
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main_vpc.id}"
  count  = "${length(var.public_subnet_cidr)}"

  tags {
    Name             = "${var.customer}_ROUTE_${var.ZONE}_${var.envr}_AF_${element(var.availability_zones_tag, count.index)}"
    "OTAP Environment" = "${var.OTAP}"
    Application      = "${var.application}"
  }
}

resource "aws_route_table_association" "public" {
  count          = "${length(var.public_subnet_cidr)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.public.*.id, count.index)}"
}

resource "aws_eip" "nat_eip" {
  vpc = true
  count = "${length(var.public_subnet_cidr)}"

  tags {
    Name               = "${var.customer}_NAT_EIP_${var.ZONE}_${var.envr}_${element(var.availability_zones_tag, count.index)}"
    "OTAP Environment" = "${var.OTAP}"
    Application        = "${var.application}"
  }
}

resource "aws_nat_gateway" "gw" {
  count         = "${length(var.public_subnet_cidr)}"
  allocation_id = "${element(aws_eip.nat_eip.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.application.*.id, count.index)}"

  tags {
    Name               = "${var.customer}_NAT_${var.ZONE}_${var.envr}_${element(var.availability_zones_tag, count.index)}"
    "OTAP Environment" = "${var.OTAP}"
    Application        = "${var.application}"
  }
}

// Route traffic from private subnet out to the internet via the NAT Gateway
resource "aws_route" "afroute_private_nat" {
  count                 = "${length(var.public_subnet_cidr)}"
  route_table_id         = "${element(aws_route_table.public.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.gw.*.id, count.index)}"
}

resource "aws_route" "afpeering_route" {
  count                      = "${var.landingzone == "yes" ? length(var.public_subnet_cidr) : 0}"
  route_table_id             = "${element(aws_route_table.public.*.id, count.index)}"
  destination_cidr_block     = "${var.peeringdest}"
  vpc_peering_connection_id  = "${var.peeringid}"
}


###################
# Backend subnets #
###################

resource "aws_subnet" "private" {
  vpc_id            = "${aws_vpc.main_vpc.id}"
  cidr_block        = "${element(var.private_subnet_cidr, count.index)}"
  availability_zone = "${element(var.availability_zones, count.index)}"
  count             = "${length(var.private_subnet_cidr)}"

  tags {
    Name             = "${var.customer}_SUBNET_${var.ZONE}_${var.envr}_AB_${element(var.availability_zones_tag, count.index)}"
    "OTAP Environment" = "${var.OTAP}"
    Application      = "${var.application}"
  }
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.main_vpc.id}"
  count  = "${length(var.private_subnet_cidr)}"

  tags {
    Name             = "${var.customer}_ROUTE_${var.ZONE}_${var.envr}_AB_${element(var.availability_zones_tag, count.index)}"
    "OTAP Environment" = "${var.OTAP}"
    Application      = "${var.application}"
  }
}

resource "aws_route_table_association" "private" {
  count          = "${length(var.private_subnet_cidr)}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}


// Route traffic from private subnet out to the internet via the NAT Gateway
resource "aws_route" "route_private_nat" {
  count                  = "${length(var.private_subnet_cidr)}"
  route_table_id         = "${element(aws_route_table.private.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.gw.*.id, count.index)}"
}

resource "aws_route" "abpeering_route" {
  count                      = "${var.landingzone == "yes" ? length(var.private_subnet_cidr) : 0}"
  route_table_id             = "${element(aws_route_table.private.*.id, count.index)}"
  destination_cidr_block     =  "${var.peeringdest}"
  vpc_peering_connection_id  = "${var.peeringid}"
}


####################
# Database subnets #
####################

resource "aws_subnet" "database" {
  vpc_id            = "${aws_vpc.main_vpc.id}"
  cidr_block        = "${element(var.database_subnet_cidr, count.index)}"
  availability_zone = "${element(var.availability_zones, count.index)}"
  count             = "${length(var.database_subnet_cidr)}"

  tags {
    Name               = "${var.customer}_SUBNET_${var.ZONE}_${var.envr}_DB_${element(var.availability_zones_tag, count.index)}"
    "OTAP Environment" = "${var.OTAP}"
    Application        = "${var.application}"
  }
}

resource "aws_route_table" "database" {
  vpc_id = "${aws_vpc.main_vpc.id}"
  count  = "${length(var.database_subnet_cidr)}"

  tags {
    Name               = "${var.customer}_ROUTE_${var.ZONE}_${var.envr}_DB_${element(var.availability_zones_tag, count.index)}"
    "OTAP Environment" = "${var.OTAP}"
    Application        = "${var.application}"
  }
}

resource "aws_route_table_association" "database" {
  count          = "${length(var.database_subnet_cidr)}"
  subnet_id      = "${element(aws_subnet.database.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.database.*.id, count.index)}"
}

// Route traffic from private subnet out to the internet via the NAT Gateway
resource "aws_route" "route_database_nat" {
  count                 = "${length(var.database_subnet_cidr)}"
  route_table_id         = "${element(aws_route_table.database.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.gw.*.id, count.index)}"
}

resource "aws_route" "dbpeering_route" {
  count                      = "${var.landingzone == "yes" ? length(var.database_subnet_cidr) : 0}"
  route_table_id             = "${element(aws_route_table.database.*.id, count.index)}"
  destination_cidr_block     =  "${var.peeringdest}"
  vpc_peering_connection_id  = "${var.peeringid}"
}



resource "aws_db_subnet_group" "RDS-subnet" {
  name = "rds-subnet"

  #subnet_ids = ["${aws_subnet.database.id}","${aws_subnet.SOGETI_CPP_SUBNET_DB_1B.id}"]
  subnet_ids = ["${aws_subnet.database.*.id}"]

  tags {
    Name             = "${var.customer}_RDSSUBNETGROUP_${var.ZONE}_${var.envr}"
    "OTAP Environment" = "${var.OTAP}"
    Application      = "${var.application}"
  }
}
