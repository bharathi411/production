provider "aws" {
  region  = "${var.region}"
  profile = "${var.profile}"
}

module "redis_server" {
    source                      = "../../../modules/ec2"
    name                        = "${var.redis_server_server_name}"
    instance_type               = "${var.redis_server_instance_type}"
    subnet_id                   = "${data.terraform_remote_state.core_prod_vpc.db_subnet_a_id}"
    number_of_instances         = "${var.number_of_instances}"
    key_name                    = "${var.prod_key_pair_name}"
    associate_public_ip_address = "false"
    user_data                   = ""
    iam_instance_profile        = "EC2_S3_ReadOnly"
    zone_id                     = "${data.terraform_remote_state.core_prod_vpc.route53_zone_id}"
    ami_id                      = "${var.redis_server_ami_id}"
    root_volume_type            = "${var.redis_root_volume_type}"
    root_volume_size            = "${var.redis_root_volume_size}"
    security_group_ids          = ["${data.terraform_remote_state.core_prod_vpc.db_security_group}", "${data.terraform_remote_state.core_prod_vpc.jenkins_security_group}"]
}
