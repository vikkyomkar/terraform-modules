variable "region" {
  type = "string"
}

variable "ami" {
  type = "string"
}

variable "instance_type" {
  type = "string"
}

variable "ssh_key" {
  type = "string"
}

variable "ebs_type" {
  type = "string"
}

variable "ebs_size" {
  type = "string"
}

variable "ebs_delete" {
  type = "string"
}

variable "asg_name" {
  description = "ASG Name"
  type        = "string"
}

variable "subnets" {
  type = "list"
}

variable "max_size" {
  type = "string"
}

variable "min_size" {
  type = "string"
}

variable "launch_time" {
  type = "string"
}

variable "health_check_type" {
  type = "string"
}

variable "Application" {
  type = "string"

  description = "Application Name"
}

variable "Environment" {
  type = "string"

  description = "Environment Name"
}

variable "owner" {
  type = "string"

  description = "owner Name"
}
