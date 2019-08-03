provider "aws" {
  region  = "${var.region}"
  profile = "${var.profile}"
}

module "mysql_server_master" {
    source                      = "../../../modules/ec2"
    name                        = "${var.mysql_server_server_name}_M"
    instance_type               = "${var.mysql_server_instance_type_master}"
    subnet_id                   = "${data.terraform_remote_state.core_prod_vpc.db_subnet_a_id}"
    number_of_instances         = "${var.number_of_instances}"
    key_name                    = "${var.prod_key_pair_name}"
    associate_public_ip_address = "false"
    user_data                   = ""
    iam_instance_profile        = "jenkins_s3_full_Access"
    zone_id                     = "${data.terraform_remote_state.core_prod_vpc.route53_zone_id}"
    ami_id                      = "ami-0ce6c39874a7b5a8a"
    root_volume_type            = "${var.mysql_root_volume_type}"
    root_volume_size            = "${var.mysql_root_volume_size_master}"
    ebs_optimized		= "true"
    disable_termination		= "true"
    security_group_ids          = ["${data.terraform_remote_state.core_prod_vpc.db_security_group}", "${data.terraform_remote_state.core_prod_vpc.jenkins_security_group}"]
}

module "mysql_server_slave" {
    source                      = "../../../modules/ec2"
    name                        = "${var.mysql_server_server_name}_S"
    instance_type               = "${var.mysql_server_instance_type_slave}"
    subnet_id                   = "${data.terraform_remote_state.core_prod_vpc.db_subnet_b_id}"
    number_of_instances         = "${var.number_of_instances}"
    key_name                    = "${var.prod_key_pair_name}"
    associate_public_ip_address = "false"
    user_data                   = ""
    iam_instance_profile        = "EC2_S3_ReadOnly"
    zone_id                     = "${data.terraform_remote_state.core_prod_vpc.route53_zone_id}"
    ami_id                      = "ami-00a842a28f75b7c56"
    root_volume_type            = "${var.mysql_root_volume_type}"
    root_volume_size            = "${var.mysql_root_volume_size_slave}"
    ebs_optimized		= "true"
    disable_termination		= "true"
    security_group_ids          = ["${data.terraform_remote_state.core_prod_vpc.db_security_group}", "${data.terraform_remote_state.core_prod_vpc.jenkins_security_group}"]
}

