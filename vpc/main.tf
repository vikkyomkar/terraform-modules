# Define the VPC 
resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc_cidr_block}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags {
    Name      = "${var.vpc_name}"
    terraform = "true"
  }
}

# Build subnets
resource "aws_subnet" "public" {
  count                   = "${length(var.public_subnets)}"
  map_public_ip_on_launch = true
  vpc_id                  = "${aws_vpc.vpc.id}"
  availability_zone       = "${element(var.zones, count.index)}"
  cidr_block              = "${element(var.public_subnets, count.index)}"

  tags {
    Name      = "${format("pub-%s-%s", var.vpc_name, element(var.zones, count.index))}"
    terraform = "true"
  }
}

resource "aws_subnet" "web_private" {
  count                   = "${length(var.web_private_subnets)}"
  map_public_ip_on_launch = false
  vpc_id                  = "${aws_vpc.vpc.id}"
  availability_zone       = "${element(var.zones, count.index)}"
  cidr_block              = "${element(var.web_private_subnets, count.index)}"

  tags {
    Name      = "${format("web_priv-%s-%s", var.vpc_name, element(var.zones, count.index))}"
    terraform = "true"
  }
}

resource "aws_subnet" "app_private" {
  count                   = "${length(var.app_private_subnets)}"
  map_public_ip_on_launch = false
  vpc_id                  = "${aws_vpc.vpc.id}"
  availability_zone       = "${element(var.zones, count.index)}"
  cidr_block              = "${element(var.app_private_subnets, count.index)}"

  tags {
    Name      = "${format("app_priv-%s-%s", var.vpc_name, element(var.zones, count.index))}"
    terraform = "true"
  }
}

resource "aws_subnet" "db" {
  count                   = "${length(var.db_subnets)}"
  map_public_ip_on_launch = false
  vpc_id                  = "${aws_vpc.vpc.id}"
  availability_zone       = "${element(var.zones, count.index)}"
  cidr_block              = "${element(var.db_subnets, count.index)}"

  tags {
    Name      = "${format("db-%s-%s", var.vpc_name, element(var.zones, count.index))}"
    terraform = "true"
  }
}

# Create gateways
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name      = "igw-${var.vpc_name}"
    terraform = "true"
  }
}

resource "aws_eip" "nat_eips" {
  count = "${length(var.zones)}"
  vpc   = "true"
}

resource "aws_nat_gateway" "nats" {
  count         = "${length(var.zones)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
  allocation_id = "${element(aws_eip.nat_eips.*.id, count.index)}"
  depends_on    = ["aws_internet_gateway.igw"]
}

# Create route tables
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name      = "rt-${var.vpc_name}-public"
    terraform = "true"
  }
}

resource "aws_route_table" "private" {
  count  = "${length(var.zones)}"
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name      = "${format("rt-%s-private-%s", var.vpc_name, element(var.zones, count.index))}"
    terraform = "true"
  }
}

resource "aws_route_table" "db" {
  count  = "${length(var.zones)}"
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name      = "${format("rt-%s-db-%s", var.vpc_name, element(var.zones, count.index))}"
    terraform = "true"
  }
}

# Associate gateways to route tables
resource "aws_route" "public" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
  route_table_id         = "${aws_route_table.public.id}"
}

resource "aws_route" "private" {
  count                  = "${length(var.zones)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.nats.*.id, count.index)}"
  route_table_id         = "${element(aws_route_table.private.*.id, count.index)}"
}

resource "aws_route" "db" {
  count                  = "${length(var.zones)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.nats.*.id, count.index)}"
  route_table_id         = "${element(aws_route_table.db.*.id, count.index)}"
}

# Associate subnets to route tables
resource "aws_route_table_association" "public" {
  count          = "${length(var.public_subnets)}"
  route_table_id = "${aws_route_table.public.id}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
}

resource "aws_route_table_association" "web_private" {
  count          = "${length(var.web_private_subnets)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
  subnet_id      = "${element(aws_subnet.web_private.*.id, count.index)}"
}

resource "aws_route_table_association" "app_private" {
  count          = "${length(var.app_private_subnets)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
  subnet_id      = "${element(aws_subnet.app_private.*.id, count.index)}"
}

resource "aws_route_table_association" "db" {
  count          = "${length(var.db_subnets)}"
  route_table_id = "${element(aws_route_table.db.*.id, count.index)}"
  subnet_id      = "${element(aws_subnet.db.*.id, count.index)}"
}
