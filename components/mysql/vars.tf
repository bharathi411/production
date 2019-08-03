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

variable "mysql_root_volume_type" {
  description = "Type of the root volume"
  default     = "gp2"
}

variable "mysql_root_volume_size_master" {
  description = "Volume size of the root partition"
  default     = "500"
}

variable "mysql_root_volume_size_slave" {
  description = "Volume size of the root partition"
  default     = "200"
}

variable "mysql_server_server_name" {
  default = "Prod_Mysql"
}

variable "mysql_server_instance_type_master" {
  default = "c4.large"
}

variable "mysql_server_instance_type_slave" {
  default = "c4.xlarge"
}

variable "mysql_server_ami_id" {
  default = "ami-0ce6c39874a7b5a8a"
}
