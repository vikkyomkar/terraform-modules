variable "lb_type" {
  description = "type of aws LB"
}

variable "elb_name" {
  description = "Name of  aws LB"
}

variable "internal" {
  description = "If true, ELB will be an internal ELB"
}

variable "instance_port" {
  description = "The port on the instance to route to"
}

variable "instance_protocol" {
  description = "The protocol to use to the instance"
}

variable "lb_port" {
  description = "The port to listen on for the load balancer"
}

variable "lb_protocol" {
  description = "The protocol to listen on"
}

variable "healthy_threshold" {
  description = "The number of checks before the instance is declared healthy"
}

variable "healthcheck_interval" {
  description = "The interval between checks"
}

variable "target_check" {
  description = "The target of the check"
}

variable "healthcheck_timeout" {
  description = "The length of time before the check times out."
}

variable "unhealthy_threshold" {
  description = "The number of checks before the instance is declared unhealthy."
}

variable "cross_zone_load_balancing" {
  description = "Enable cross-zone load balancing. Default: true"
  default     = "false"
}

variable "idle_timeout" {
  description = "The time in seconds that the connection is allowed to be idle. Default: 60"
  default     = 60
}

variable "conn_drain" {
  description = "A 1/0 to indicate if elb connection draining is enabled or not"
  default     = "1"
}

variable "conn_drain_timeout" {
  description = "The time in seconds to allow for connections to drain. Default: 300"
  default     = 300
}

variable "Application" {
  description = "Application Name"
}

variable "Environment" {
  description = "Environment Name"
}

variable "owner" {
  description = "owner Name"
}
