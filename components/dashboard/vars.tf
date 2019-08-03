variable "region" {
  description = "Region for launching subnets"
  default     = "ap-south-1"
}

variable "profile" {
  description = "Aws Profiles for Infra"
  default     = "chqbook"
}

variable "chqbook_dashboard_server_name" {
  default = "Prod_Dashboard"
}

variable "chqbook_dashboard_instance_type" {
  default = "t2.nano"
}

variable "chqbook_dashboard_ami_id" {
  default = "ami-0ce6c39874a7b5a8a"
}

variable "prod_key_pair_name" {
  default = "default"
}

variable "number_of_instances" {
  description = "Number of instance you want to launch"
  default     = "1"
}

variable "dashboard_root_volume_type" {
  description = "Type of the root volume"
  default     = "gp2"
}

variable "dashboard_root_volume_size" {
  description = "Volume size of the root partition"
  default     = "20"
}

variable "route53_zone_name" {
  description = "Route53 record zone name"
  default     = "internal.prod.com"
}
