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

variable "metro_root_volume_type" {
  description = "Type of the root volume"
  default     = "gp2"
}

variable "metro_root_volume_size" {
  description = "Volume size of the root partition"
  default     = "10"
}

variable "chqbook_metro_server_name" {
  default = "Prod_metro"
}

variable "chqbook_metro_instance_type" {
  default = "t2.nano"
}

variable "chqbook_metro_ami_id" {
  default = "ami-00b6a8a2bd28daf19"
}

variable "route53_zone_name" {
  description = "Route53 record zone name"
  default     = "internal.prod.com"
}
