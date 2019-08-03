provider "aws" {
  region  = "${var.region}"
  profile = "${var.profile}"
}

resource "aws_security_group" "chqbook_admin_security_group" {
  name        = "chqbook_admin_security_group"
  vpc_id      = "${data.terraform_remote_state.core_prod_vpc.vpc_id}"
  
  ingress {
    from_port       = 4211
    to_port         = 4211
    protocol        = "tcp"
    security_groups = ["${data.terraform_remote_state.core_prod_vpc.internal_alb_sg_id}"]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${data.terraform_remote_state.core_prod_vpc.internal_alb_sg_id}"]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = ["${data.terraform_remote_state.core_prod_vpc.internal_alb_sg_id}"]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${data.terraform_remote_state.core_prod_vpc.bastion_security_group_id}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
      Name = "chqbook_admin_security_group"
  }
}

module "chqbook_admin_1" {
    source                      = "../../../modules/ec2"
    name                        = "${var.chqbook_admin_server_name}_1"
    instance_type               = "${var.chqbook_admin_instance_type}"
    subnet_id                   = "${data.terraform_remote_state.core_prod_vpc.app_subnet_a_id}"
    number_of_instances         = "${var.number_of_instances}"
    key_name                    = "${var.prod_key_pair_name}"
    associate_public_ip_address = "false"
    user_data                   = ""
    iam_instance_profile        = "jenkins_s3_full_Access"
    zone_id                     = "${data.terraform_remote_state.core_prod_vpc.route53_zone_id}"
    ami_id                      = "${var.chqbook_admin_ami_id}"
    root_volume_type            = "${var.admin_root_volume_type}"
    root_volume_size            = "${var.admin_root_volume_size}"
    security_group_ids          = ["${data.terraform_remote_state.core_prod_vpc.jenkins_security_group}", "${aws_security_group.chqbook_admin_security_group.id}"]
}

module "chqbook_admin_2" {
    source                      = "../../../modules/ec2"
    name                        = "${var.chqbook_admin_server_name}_2"
    instance_type               = "${var.chqbook_admin_instance_type}"
    subnet_id                   = "${data.terraform_remote_state.core_prod_vpc.app_subnet_b_id}"
    number_of_instances         = "${var.number_of_instances}"
    key_name                    = "${var.prod_key_pair_name}"
    associate_public_ip_address = "false"
    iam_instance_profile        = "jenkins_s3_full_Access"
    user_data                   = ""
    zone_id                     = "${data.terraform_remote_state.core_prod_vpc.route53_zone_id}"
    ami_id                      = "${var.chqbook_admin_ami_id}"
    root_volume_type            = "${var.admin_root_volume_type}"
    root_volume_size            = "${var.admin_root_volume_size}"
    security_group_ids          = ["${data.terraform_remote_state.core_prod_vpc.jenkins_security_group}", "${aws_security_group.chqbook_admin_security_group.id}"]
}

#module "chqbook_admin_3" {
#    source                      = "../../../modules/ec2"
#    name                        = "${var.chqbook_admin_server_name}_3"
#    instance_type               = "${var.chqbook_admin_instance_type}"
#    subnet_id                   = "${data.terraform_remote_state.core_prod_vpc.app_subnet_b_id}"
#    number_of_instances         = "${var.number_of_instances}"
#    key_name                    = "${var.prod_key_pair_name}"
#    associate_public_ip_address = "false"
#    iam_instance_profile        = "jenkins_s3_full_Access"
#    user_data                   = ""
#    zone_id                     = "${data.terraform_remote_state.core_prod_vpc.route53_zone_id}"
#    ami_id                      = "ami-0fcdc1ad96ca39afd"
#    root_volume_type            = "${var.admin_root_volume_type}"
#    root_volume_size            = "${var.admin_root_volume_size}"
#    security_group_ids          = ["${data.terraform_remote_state.core_prod_vpc.jenkins_security_group}", "${aws_security_group.chqbook_admin_security_group.id}"]
#}

#module "chqbook_admin_4" {
#    source                      = "../../../modules/ec2"
#    name                        = "${var.chqbook_admin_server_name}_4"
#    instance_type               = "${var.chqbook_admin_instance_type}"
#    subnet_id                   = "${data.terraform_remote_state.core_prod_vpc.app_subnet_b_id}"
#    number_of_instances         = "${var.number_of_instances}"
#    key_name                    = "${var.prod_key_pair_name}"
#    associate_public_ip_address = "false"
#    iam_instance_profile        = "jenkins_s3_full_Access"
#    user_data                   = ""
#    zone_id                     = "${data.terraform_remote_state.core_prod_vpc.route53_zone_id}"
#    ami_id                      = "ami-0fcdc1ad96ca39afd"
#    root_volume_type            = "${var.admin_root_volume_type}"
#    root_volume_size            = "${var.admin_root_volume_size}"
#    security_group_ids          = ["${data.terraform_remote_state.core_prod_vpc.jenkins_security_group}", "${aws_security_group.chqbook_admin_security_group.id}"]
#}

module "chqbook-admin-tg" {
  source                = "../../../modules/targetgroup"
  target_group_name     = "admin-panel"
  backend_port          = "4211"
  backend_protocol      = "HTTP"
  vpc_id                = "${data.terraform_remote_state.core_prod_vpc.vpc_id}"
  health_check_interval = "10"
  health_check_path     = "/"
  health_check_port     = "traffic-port"
  health_check_timeout  = "5"
  health_check_matcher  = "200-301"
  target_type           = "instance"
}

module "admin1_tg_register" {
  source           = "../../../modules/targetgroup_attachment"
  target_group_arn = "${module.chqbook-admin-tg.arn}"
  instance_id      = "${module.chqbook_admin_1.id[0]}"
}

module "admin2_tg_register" {
  source           = "../../../modules/targetgroup_attachment"
  target_group_arn = "${module.chqbook-admin-tg.arn}"
  instance_id      = "${module.chqbook_admin_2.id[0]}"
}

#module "admin3_tg_register" {
#  source           = "../../../modules/targetgroup_attachment"
#  target_group_arn = "${module.chqbook-admin-tg.arn}"
#  instance_id      = "${module.chqbook_admin_3.id[0]}"
#}

#module "admin4_tg_register" {
#  source           = "../../../modules/targetgroup_attachment"
#  target_group_arn = "${module.chqbook-admin-tg.arn}"
#  instance_id      = "${module.chqbook_admin_4.id[0]}"
#}

module "internal_alb_admin_listener_rule_90" {
  source           = "../../../modules/alb_listener_rule"
  listener_arn     = "${data.terraform_remote_state.frontend.internal_alb_listener_arn}"
  priority         = "90"
  target_group_arn = "${module.chqbook-admin-tg.arn}"
  host-header      = "admin.chqbook.com"
}

#module "internal_alb_admin__https_listener_rule_200" {
#  source           = "../../../modules/alb_listener_rule"
#  listener_arn     = "${data.terraform_remote_state.frontend.internal_https_alb_listener_arn}"
#  priority         = "200"
#  target_group_arn = "${module.chqbook-admin-tg.arn}"
#  host-header      = "admin.uat2.chqbook.com"
#}
