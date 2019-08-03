variable "region" {
  description = "Region for launching subnets"
  default     = "ap-south-1"
}

variable "profile" {
  description = "Aws Profiles for Infra"
  default     = "chqbook"
}

variable "vpc_cidr" {
    description = "CIDR of the VPC" 
    default     = "10.10.0.0/16"
}

variable "vpc_name" {
  description = "Name of the VPC"
  default     = "prod_vpc"
}

variable "openvpn_ami_id" {
  default = "ami-0d773a3b7bb2bb1c1"
}

variable "route53_zone_name" {
  description = "Route53 record zone name"
  default     = "internal.prod.com"
}

variable "enable_dns_hostnames" {
  description = "Whether to enable hostname communication or not"
  default     = "true"
}

variable "enable_dns_support" {
  description = "Whether to enable dns support or not for Route53"
  default     = "true"
}

variable "prod_key_pair_name" {
  default = "default"
}

variable "pub_sub_a_cidr" {
  description = "CIDR block for the public subnet of aza"
  default     = "10.10.0.0/20"
}

variable "pub_sub_a_name" {
  description = "Name of the public subnet of aza"
  default     = "pub_sub_aza"
}

variable "pub_sub_b_cidr" {
  description = "CIDR block for the public subnet of azb"
  default     = "10.10.16.0/20"
}

variable "pub_sub_b_name" {
  description = "Name of the public subnet of azb"
  default     = "pub_sub_azb"
}

variable "app_sub_a_cidr" {
  description = "CIDR block for the private subnet of aza"
  default     = "10.10.32.0/20"
}

variable "app_sub_a_name" {
  description = "Name of the private subnet of aza"
  default     = "pvt_sub_aza"
}

variable "app_sub_b_cidr" {
  description = "CIDR block for the private subnet of azb"
  default     = "10.10.64.0/20"
}

variable "app_sub_b_name" {
  description = "Name of the private subnet of azb"
  default     = "pvt_sub_azb"
}

variable "db_sub_a_cidr" {
  description = "Name of the DB subnet CIDR"
  default     = "10.10.96.0/20"
}

variable "db_sub_a_name" {
  default = "db_sub_aza"
}

variable "db_sub_b_cidr" {
  description = "Name of the DB subnet CIDR"
  default     = "10.10.128.0/20"
}

variable "db_sub_b_name" {
  default = "db_sub_azb"
}

variable "management_sub_a_cidr" {
  default = "10.10.160.0/20"
}

variable "management_sub_a_name" {
  default = "management_sub_aza"
}

variable "public_route_table_name" {
  description = "Name of the public route table"
  default     = "public_route_table"
}

variable "private_route_table_name" {
  description = "Name of the private route table"
  default     = "private_route_table"
}

variable "source_vpc_id" {
  default = "vpc-005eda7a388dc21c2"
}

variable "source_vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "peer_vpc_cidr" {
  default = "10.10.0.0/16"
}

variable "source_route_table_id" {
  default = "rtb-044e717ce4f156776"
}

variable "bastion_server_name" {
  description = "Name of the bastion server name"
  default     = "Prod_Bastion"
}

variable "bastion_instance_type" {
  description = "Instance type of the bastion server"
  default     = "t2.micro"
}

variable "bastion_ami_id" {
  description = "AMI Id for the Bastion Server"
  default     = "ami-06bcd1131b2f55803"
}

variable "number_of_instances" {
  description = "Number of instance you want to launch"
  default     = "1"
}

variable "bastion_root_volume_type" {
  description = "Type of the root volume"
  default     = "gp2"
}

variable "bastion_root_volume_size" {
  description = "Volume size of the root partition"
  default     = "10"
}

variable "bastion_security_group_name" {
  description = "Name of the Bastion Security Group"
  default     = "bastion_sg"
}

variable "jenkins_security_group_ip" {
  default = "10.0.3.179/32"
}
