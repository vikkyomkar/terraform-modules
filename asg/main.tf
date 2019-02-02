resource "aws_launch_configuration" "asg_config" {

  image_id             = "${var.ami}"
  instance_type        = "${var.instance_type}"
  security_groups      = ["${concat(var.extra_security_groups, list(aws_security_group.current.id))}"]

  lifecycle {
    create_before_destroy = true
    ignore_changes        = ["image_id", "name_prefix"]
  }

  root_block_device {
    volume_type           = "${var.ebs_type}"
    volume_size           = "${var.ebs_size}"
    delete_on_termination = "${var.ebs_delete}"
  }
}
