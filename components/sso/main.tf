provider "aws" {
  region  = "${var.region}"
  profile = "${var.profile}"
}

module "chqbook-sso-tg" {
  source                = "../../../modules/targetgroup"
  target_group_name     = "sso"
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

module "internal_alb_sso_listener_rule_140" {
  source           = "../../../modules/alb_listener_rule"
  listener_arn     = "${data.terraform_remote_state.frontend.internal_alb_listener_arn}"
  priority         = "140"
  target_group_arn = "${module.chqbook-sso-tg.arn}"
  host-header      = "accounts.chqbook.com"
}

#module "internal_alb_sso_listener_rule_270" {
#  source           = "../../../modules/alb_listener_rule"
#  listener_arn     = "${data.terraform_remote_state.frontend.internal_https_alb_listener_arn}"
#  priority         = "270"
#  target_group_arn = "${module.chqbook-sso-tg.arn}"
#  host-header      = "accounts.uat2.chqbook.com"
#}

module "sso1_tg_register" {
  source           = "../../../modules/targetgroup_attachment"
  target_group_arn = "${module.chqbook-sso-tg.arn}"
  instance_id      = "${data.terraform_remote_state.dashboard.dashboard1_id[0]}"
}

module "sso2_tg_register" {
  source           = "../../../modules/targetgroup_attachment"
  target_group_arn = "${module.chqbook-sso-tg.arn}"
  instance_id      = "${data.terraform_remote_state.dashboard.dashboard2_id[0]}"
}

#module "sso3_tg_register" {
#  source           = "../../../modules/targetgroup_attachment"
#  target_group_arn = "${module.chqbook-sso-tg.arn}"
#  instance_id      = "${data.terraform_remote_state.dashboard.dashboard3_id[0]}"
#}

#module "sso4_tg_register" {
#  source           = "../../../modules/targetgroup_attachment"
#  target_group_arn = "${module.chqbook-sso-tg.arn}"
#  instance_id      = "${data.terraform_remote_state.dashboard.dashboard4_id[0]}"
#}
resource "aws_route53_record" "sso1" {
  zone_id = "${data.terraform_remote_state.core_prod_vpc.route53_zone_id}"
  name    = "sso1.${var.route53_zone_name}"
  type    = "A"
  ttl     = "300"
  records = ["${data.terraform_remote_state.dashboard.dashboard_1_private_ip}"]
}

resource "aws_route53_record" "sso2" {
  zone_id = "${data.terraform_remote_state.core_prod_vpc.route53_zone_id}"
  name    = "sso2.${var.route53_zone_name}"
  type    = "A"
  ttl     = "300"
  records = ["${data.terraform_remote_state.dashboard.dashboard_2_private_ip}"]
}

#resource "aws_route53_record" "sso3" {
#  zone_id = "${data.terraform_remote_state.core_prod_vpc.route53_zone_id}"
#  name    = "sso3.${var.route53_zone_name}"
#  type    = "A"
#  ttl     = "300"
#  records = ["${data.terraform_remote_state.dashboard.dashboard_3_private_ip}"]
#}

#resource "aws_route53_record" "sso4" {
#  zone_id = "${data.terraform_remote_state.core_prod_vpc.route53_zone_id}"
#  name    = "sso4.${var.route53_zone_name}"
#  type    = "A"
#  ttl     = "300"
#  records = ["${data.terraform_remote_state.dashboard.dashboard_4_private_ip}"]
#}