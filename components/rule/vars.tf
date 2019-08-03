variable "region" {
  description = "Region for launching subnets"
  default     = "ap-south-1"
}

variable "profile" {
  description = "Aws Profiles for Infra"
  default     = "chqbook"
}

variable "prod_key_pair_name" {
  default = "default"
}

variable "number_of_instances" {
  description = "Number of instance you want to launch"
  default     = "1"
}

variable "rule_root_volume_type" {
  description = "Type of the root volume"
  default     = "gp2"
}

variable "rule_root_volume_size" {
  description = "Volume size of the root partition"
  default     = "20"
}

variable "chqbook_rule_server_name" {
  default = "Prod_Rule"
}

variable "chqbook_rule_instance_type" {
  default = "t2.small"
}

variable "chqbook_rule_ami_id" {
  default = "ami-0ce6c39874a7b5a8a"
}

variable "route53_zone_name" {
  description = "Route53 record zone name"
  default     = "internal.prod.com"
}

variable "loadbalancer_zone_id" {
  default = "ZP97RAFLXTNZK"
}
