provider "aws" {
  region  = "${var.region}"
  profile = "${var.profile}"
}

module "chqbook-metro-tg" {
  source                = "../../../modules/targetgroup"
  target_group_name     = "metro"
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

module "internal_alb_metro_listener_rule_150" {
  source           = "../../../modules/alb_listener_rule"
  listener_arn     = "${data.terraform_remote_state.frontend.internal_alb_listener_arn}"
  priority         = "150"
  target_group_arn = "${module.chqbook-metro-tg.arn}"
  host-header      = "metro.chqbook.com"
}

#module "internal_alb_metro_listener_rule_240" {
#  source           = "../../../modules/alb_listener_rule"
#  listener_arn     = "${data.terraform_remote_state.frontend.internal_https_alb_listener_arn}"
#  priority         = "240"
#  target_group_arn = "${module.chqbook-metro-tg.arn}"
#  host-header      = "metro.uat2.chqbook.com"
#}

module "metro1_tg_register" {
  source           = "../../../modules/targetgroup_attachment"
  target_group_arn = "${module.chqbook-metro-tg.arn}"
  instance_id      = "${data.terraform_remote_state.dashboard.dashboard1_id[0]}"
}

module "metro2_tg_register" {
  source           = "../../../modules/targetgroup_attachment"
  target_group_arn = "${module.chqbook-metro-tg.arn}"
  instance_id      = "${data.terraform_remote_state.dashboard.dashboard2_id[0]}"
}

#module "metro3_tg_register" {
#  source           = "../../../modules/targetgroup_attachment"
#  target_group_arn = "${module.chqbook-metro-tg.arn}"
#  instance_id      = "${data.terraform_remote_state.dashboard.dashboard3_id[0]}"
#}
#
#module "metro4_tg_register" {
#  source           = "../../../modules/targetgroup_attachment"
#  target_group_arn = "${module.chqbook-metro-tg.arn}"
#  instance_id      = "${data.terraform_remote_state.dashboard.dashboard3_id[0]}"
#}

resource "aws_route53_record" "metro1" {
  zone_id = "${data.terraform_remote_state.core_prod_vpc.route53_zone_id}"
  name    = "metro1.${var.route53_zone_name}"
  type    = "A"
  ttl     = "300"
  records = ["${data.terraform_remote_state.dashboard.dashboard_1_private_ip}"]
}

resource "aws_route53_record" "metro2" {
  zone_id = "${data.terraform_remote_state.core_prod_vpc.route53_zone_id}"
  name    = "metro2.${var.route53_zone_name}"
  type    = "A"
  ttl     = "300"
  records = ["${data.terraform_remote_state.dashboard.dashboard_2_private_ip}"]
}

#resource "aws_route53_record" "metro3" {
#  zone_id = "${data.terraform_remote_state.core_prod_vpc.route53_zone_id}"
#  name    = "metro3.${var.route53_zone_name}"
#  type    = "A"
#  ttl     = "300"
#  records = ["${data.terraform_remote_state.dashboard.dashboard_3_private_ip}"]
#}

#resource "aws_route53_record" "metro4" {
#  zone_id = "${data.terraform_remote_state.core_prod_vpc.route53_zone_id}"
#  name    = "metro4.${var.route53_zone_name}"
#  type    = "A"
#  ttl     = "300"
#  records = ["${data.terraform_remote_state.dashboard.dashboard_4_private_ip}"]
#}