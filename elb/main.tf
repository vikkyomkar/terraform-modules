### classic loadbalancer
resource "aws_elb" "clb" {
  count           = "${var.lb_type == "clb" ? 1 : 0 }"
  name            = "${var.Environment}-${var.elb_name}"
  internal        = "${var.internal}"
  subnets         = ["${var.subnets}"]
  security_groups = ["${var.sg}"]

  listener {
    instance_port     = "${var.instance_port}"
    instance_protocol = "${var.instance_protocol}"
    lb_port           = "${var.lb_port}"
    lb_protocol       = "${var.lb_protocol}"
  }

  health_check {
    healthy_threshold   = "${var.healthy_threshold}"
    interval            = "${var.healthcheck_interval}"
    target              = "${var.target_check}"
    timeout             = "${var.healthcheck_timeout}"
    unhealthy_threshold = "${var.unhealthy_threshold}"
  }

  cross_zone_load_balancing   = "${var.cross_zone_load_balancing}"
  idle_timeout                = "${var.idle_timeout}"
  connection_draining         = "${var.conn_drain}"
  connection_draining_timeout = "${var.conn_drain_timeout}"

  tags {
    Name        = "${var.Environment}-${var.elb_name}"
    Application = "${var.Application}"
    Environment = "${var.Environment}"
    owner       = "${var.owner}"
  }
}
