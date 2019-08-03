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

variable "redis_root_volume_type" {
  description = "Type of the root volume"
  default     = "gp2"
}

variable "redis_root_volume_size" {
  description = "Volume size of the root partition"
  default     = "50"
}

variable "redis_server_server_name" {
  default = "Prod_Redis"
}

variable "redis_server_instance_type" {
  default = "t2.medium"
}

variable "redis_server_ami_id" {
  default = "ami-0ce6c39874a7b5a8a"
}
