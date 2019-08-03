variable "region" {
  description = "Region for launching subnets"
  default     = "ap-south-1"
}

variable "profile" {
  description = "Aws Profiles for Infra"
  default     = "chqbook"
}

variable "certificate_arn" {
  default = "arn:aws:acm:ap-south-1:036955336065:certificate/b78019a9-db2b-48e6-bee8-9272f749d47e"
}

variable "security_policy" {
  default = "ELBSecurityPolicy-FS-2018-06"
}

variable "prod_key_pair_name" {
  default = "default"
}

variable "number_of_instances" {
  description = "Number of instance you want to launch"
  default     = "1"
}

variable "chqbook_frontend_server_name" {
  default = "Prod_Frontend"
}

variable "chqbook_frontend_instance_type" {
  default = "t2.medium"
}

variable "chqbook_frontend_ami_id" {
  default = "ami-0ce6c39874a7b5a8a"
}

variable "frontend_root_volume_type" {
  description = "Type of the root volume"
  default     = "gp2"
}

variable "frontend_root_volume_size" {
  description = "Volume size of the root partition"
  default     = "20"
}

variable "route53_zone_name" {
  description = "Route53 record zone name"
  default     = "internal.prod.com"
}

variable "loadbalancer_zone_id" {
  default = "ZP97RAFLXTNZK"
}
