provider "aws" {
    region  = "${var.region}"
    profile = "${var.profile}"
}

resource "aws_security_group" "chqbook_dashboard_security_group" {
  name        = "chqbook_dashboard_security_group"
  vpc_id      = "${data.terraform_remote_state.core_prod_vpc.vpc_id}"
  
  ingress {
    from_port       = 8080
    to_port         = 8080
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
      Name = "chqbook_dashboard_security_group"
  }
}

module "chqbook_dashboard_1" {
    source                      = "../../../modules/ec2"
    name                        = "${var.chqbook_dashboard_server_name}_1"
    instance_type               = "${var.chqbook_dashboard_instance_type}"
    subnet_id                   = "${data.terraform_remote_state.core_prod_vpc.app_subnet_a_id}"
    number_of_instances         = "${var.number_of_instances}"
    key_name                    = "${var.prod_key_pair_name}"
    associate_public_ip_address = "false"
    zone_id                     = "${data.terraform_remote_state.core_prod_vpc.route53_zone_id}"
    user_data                   = ""
    iam_instance_profile        = "jenkins_s3_full_Access"
    ami_id                      = "${var.chqbook_dashboard_ami_id}"
    root_volume_type            = "${var.dashboard_root_volume_type}"
    root_volume_size            = "${var.dashboard_root_volume_size}"
    security_group_ids          = ["${data.terraform_remote_state.core_prod_vpc.jenkins_security_group}", "${aws_security_group.chqbook_dashboard_security_group.id}"]
}

module "chqbook_dashboard_2" {
    source                      = "../../../modules/ec2"
    name                        = "${var.chqbook_dashboard_server_name}_2"
    instance_type               = "${var.chqbook_dashboard_instance_type}"
    subnet_id                   = "${data.terraform_remote_state.core_prod_vpc.app_subnet_b_id}"
    zone_id                     = "${data.terraform_remote_state.core_prod_vpc.route53_zone_id}"
    number_of_instances         = "${var.number_of_instances}"
    key_name                    = "${var.prod_key_pair_name}"
    associate_public_ip_address = "false"
    user_data                   = ""
    iam_instance_profile        = "jenkins_s3_full_Access"
    ami_id                      = "${var.chqbook_dashboard_ami_id}"
    root_volume_type            = "${var.dashboard_root_volume_type}"
    root_volume_size            = "${var.dashboard_root_volume_size}"
    security_group_ids          = ["${data.terraform_remote_state.core_prod_vpc.jenkins_security_group}", "${aws_security_group.chqbook_dashboard_security_group.id}"]
}

#module "chqbook_dashboard_3" {
#    source                      = "../../../modules/ec2"
#    name                        = "${var.chqbook_dashboard_server_name}_3"
#    instance_type               = "${var.chqbook_dashboard_instance_type}"
#    subnet_id                   = "${data.terraform_remote_state.core_prod_vpc.app_subnet_b_id}"
#    zone_id                     = "${data.terraform_remote_state.core_prod_vpc.route53_zone_id}"
#    number_of_instances         = "${var.number_of_instances}"
#    key_name                    = "${var.prod_key_pair_name}"
#    associate_public_ip_address = "false"
#    user_data                   = ""
#    iam_instance_profile        = "jenkins_s3_full_Access"
#    ami_id                      = "ami-03ba0dbe8afa745fa"
#    root_volume_type            = "${var.dashboard_root_volume_type}"
#    root_volume_size            = "${var.dashboard_root_volume_size}"
#    security_group_ids          = ["${data.terraform_remote_state.core_prod_vpc.jenkins_security_group}", "${aws_security_group.chqbook_dashboard_security_group.id}"]
#}

#module "chqbook_dashboard_4" {
#    source                      = "../../../modules/ec2"
#    name                        = "${var.chqbook_dashboard_server_name}_4"
#    instance_type               = "${var.chqbook_dashboard_instance_type}"
#    subnet_id                   = "${data.terraform_remote_state.core_prod_vpc.app_subnet_b_id}"
#    zone_id                     = "${data.terraform_remote_state.core_prod_vpc.route53_zone_id}"
#    number_of_instances         = "${var.number_of_instances}"
#    key_name                    = "${var.prod_key_pair_name}"
#    associate_public_ip_address = "false"
#    user_data                   = ""
#    iam_instance_profile        = "jenkins_s3_full_Access"
#    ami_id                      = "ami-03ba0dbe8afa745fa"
#    root_volume_type            = "${var.dashboard_root_volume_type}"
#    root_volume_size            = "${var.dashboard_root_volume_size}"
#    security_group_ids          = ["${data.terraform_remote_state.core_prod_vpc.jenkins_security_group}", "${aws_security_group.chqbook_dashboard_security_group.id}"]
#}
module "chqbook-dashboard-tg" {
  source                = "../../../modules/targetgroup"
  target_group_name     = "dashboard"
  backend_port          = "80"
  backend_protocol      = "HTTP"
  vpc_id                = "${data.terraform_remote_state.core_prod_vpc.vpc_id}"
  health_check_interval = "10"
  health_check_path     = "/"
  health_check_port     = "traffic-port"
  health_check_timeout  = "5"
  health_check_matcher  = "200-301"
  target_type           = "instance"
}

module "internal_alb_dashboard_listener_rule_110" {
  source           = "../../../modules/alb_listener_rule"
  listener_arn     = "${data.terraform_remote_state.frontend.internal_alb_listener_arn}"
  priority         = "110"
  target_group_arn = "${module.chqbook-dashboard-tg.arn}"
  host-header      = "dashboard.chqbook.com"
}

#module "internal_alb_dashboard_listener_rule_220" {
#  source           = "../../../modules/alb_listener_rule"
#  listener_arn     = "${data.terraform_remote_state.frontend.internal_https_alb_listener_arn}"
#  priority         = "220"
#  target_group_arn = "${module.chqbook-dashboard-tg.arn}"
#  host-header      = "dashboard.uat2.chqbook.com"
#}

module "dashboard1_tg_register" {
  source           = "../../../modules/targetgroup_attachment"
  target_group_arn = "${module.chqbook-dashboard-tg.arn}"
  instance_id      = "${module.chqbook_dashboard_1.id[0]}"
}

module "dashboard2_tg_register" {
  source           = "../../../modules/targetgroup_attachment"
  target_group_arn = "${module.chqbook-dashboard-tg.arn}"
  instance_id      = "${module.chqbook_dashboard_2.id[0]}"
}

#module "dashboard3_tg_register" {
#  source           = "../../../modules/targetgroup_attachment"
#  target_group_arn = "${module.chqbook-dashboard-tg.arn}"
#  instance_id      = "${module.chqbook_dashboard_3.id[0]}"
#}

#module "dashboard4_tg_register" {
#  source           = "../../../modules/targetgroup_attachment"
#  target_group_arn = "${module.chqbook-dashboard-tg.arn}"
#  instance_id      = "${module.chqbook_dashboard_4.id[0]}"
#}