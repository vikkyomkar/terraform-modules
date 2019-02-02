# Outputs needed by other resources
output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "cidr_block" {
  value = "${aws_vpc.vpc.vpc_cidr_block}"
}


output "db_subnets" {
  value = ["${aws_subnet.db.*.id}"]
}


output "web_private_subnets" {
  value = ["${aws_subnet.web_private.*.id}"]
}

output "app_private_subnets" {
  value = ["${aws_subnet.app_private.*.id}"]
}


output "public_subnets" {
  value = ["${aws_subnet.public.*.id}"]
}

