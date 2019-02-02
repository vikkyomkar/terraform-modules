resource "aws_launch_configuration" "asg_config" {
  image_id        = "${var.ami}"
  instance_type   = "${var.instance_type}"
  security_groups = ["${var.sg}"]
  key_name        = "${var.ssh_key}"

  root_block_device {
    volume_type           = "${var.ebs_type}"
    volume_size           = "${var.ebs_size}"
    delete_on_termination = "${var.ebs_delete}"
  }
}

resource "aws_autoscaling_group" "asg_create" {
  name = "${var.asg_name}"

  force_delete         = true
  vpc_zone_identifier  = ["${var.subnets}"]
  launch_configuration = "${aws_launch_configuration.asg_config.name}"

  max_size = "${var.max_size}"
  min_size = "${var.min_size}"

  health_check_grace_period = "${var.launch_time}"
  health_check_type         = "${var.health_check_type}"

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
  ]

  tag {
    key                 = "Name"
    value               = "${var.asg_name}-server"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "Environment"
    value               = "${var.Environment}"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "Application"
    value               = "${var.Application}"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "owner"
    value               = "${var.owner}"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "terraform"
    value               = "true"
    propagate_at_launch = "true"
  }
}
