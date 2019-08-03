variable "region" {
  description = "Region for launching subnets"
  default     = "ap-south-1"
}

variable "profile" {
  description = "Aws Profiles for Infra"
  default     = "chqbook"
}

variable "nginx_server_name" {
  default = "Prod_Nginx"
}

variable "nginx_instance_type" {
  default = "t2.micro"
}

variable "nginx_ami_id" {
  default = "ami-0ce6c39874a7b5a8a"
}

variable "prod_key_pair_name" {
  default = "default"
}

variable "number_of_instances" {
  description = "Number of instance you want to launch"
  default     = "1"
}

variable "nginx_root_volume_type" {
  description = "Type of the root volume"
  default     = "gp2"
}

variable "nginx_root_volume_size" {
  description = "Volume size of the root partition"
  default     = "20"
}

variable "route53_zone_name" {
  default = "internal.prod.com"
}

variable "certificate_arn" {
  default = "arn:aws:acm:ap-south-1:036955336065:certificate/b78019a9-db2b-48e6-bee8-9272f749d47e"
}

variable "security_policy" {
  default = "ELBSecurityPolicy-FS-2018-06"
}
