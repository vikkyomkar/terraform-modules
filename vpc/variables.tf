variable vpc_name {
  type = "string"
}

variable vpc_cidr_block {
  type = "string"
}

variable zones {
  type = "list"
}

variable public_subnets {
  type = "list"
}

variable web_private_subnets {
  type = "list"
}

variable app_private_subnets {
  type = "list"
}

variable db_subnets {
  type = "list"
}
