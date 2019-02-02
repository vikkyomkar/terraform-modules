output "lb_id" {
  value = "${aws_elb.clb.*.id}"
}

output "lb_dns_name" {
  value = "${aws_elb.clb.dns_name}"
}
