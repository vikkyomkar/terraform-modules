output "lb_id" {
  value = "${aws_elb.clb.*.id}"
}
