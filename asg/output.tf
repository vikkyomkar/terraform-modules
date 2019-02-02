output "asg_id" {
  value = "${aws_autoscaling_group.asg_create.*.id}"
}
