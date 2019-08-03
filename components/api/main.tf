provider "aws" {
  region  = "${var.region}"
  profile = "${var.profile}"
}

resource "aws_security_group" "backend_security_group" {
  name        = "backend_security_group"
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
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${data.terraform_remote_state.core_prod_vpc.bastion_security_group_id}"]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
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
      Name = "backend_security_group"
  }
}

module "chqbook_api_1" {
    source                      = "../../../modules/ec2"
    name                        = "${var.chqbook_api_server_name}_1"
    instance_type               = "${var.chqbook_api_instance_type}"
    subnet_id                   = "${data.terraform_remote_state.core_prod_vpc.app_subnet_a_id}"
    number_of_instances         = "${var.number_of_instances}"
    key_name                    = "${var.prod_key_pair_name}"
    associate_public_ip_address = "false"
    user_data                   = ""
    iam_instance_profile        = "jenkins_s3_full_Access"
    zone_id                     = "${data.terraform_remote_state.core_prod_vpc.route53_zone_id}"
    ami_id                      = "${var.chqbook_api_ami_id}"
    root_volume_type            = "${var.api_root_volume_type}"
    root_volume_size            = "${var.api_root_volume_size}"
    security_group_ids          = ["${data.terraform_remote_state.core_prod_vpc.jenkins_security_group}", "${aws_security_group.backend_security_group.id}"]
}

module "chqbook_api_2" {
    source                      = "../../../modules/ec2"
    name                        = "${var.chqbook_api_server_name}_2"
    instance_type               = "${var.chqbook_api_instance_type}"
    subnet_id                   = "${data.terraform_remote_state.core_prod_vpc.app_subnet_b_id}"
    number_of_instances         = "${var.number_of_instances}"
    key_name                    = "${var.prod_key_pair_name}"
    associate_public_ip_address = "false"
    user_data                   = ""
    iam_instance_profile        = "jenkins_s3_full_Access"
    zone_id                     = "${data.terraform_remote_state.core_prod_vpc.route53_zone_id}"
    ami_id                      = "${var.chqbook_api_ami_id}"
    root_volume_type            = "${var.api_root_volume_type}"
    root_volume_size            = "${var.api_root_volume_size}"
    security_group_ids          = ["${data.terraform_remote_state.core_prod_vpc.jenkins_security_group}", "${aws_security_group.backend_security_group.id}"]
}

module "chqbook_api_3" {
    source                      = "../../../modules/ec2"
    name                        = "${var.chqbook_api_server_name}_3"
    instance_type               = "${var.chqbook_api_instance_type}"
    subnet_id                   = "${data.terraform_remote_state.core_prod_vpc.app_subnet_a_id}"
    number_of_instances         = "${var.number_of_instances}"
    key_name                    = "${var.prod_key_pair_name}"
    associate_public_ip_address = "false"
    user_data                   = ""
    iam_instance_profile        = "jenkins_s3_full_Access"
    zone_id                     = "${data.terraform_remote_state.core_prod_vpc.route53_zone_id}"
    ami_id                      = "ami-0de5b62aa7ffa49f2"
    root_volume_type            = "${var.api_root_volume_type}"
    root_volume_size            = "${var.api_root_volume_size}"
    security_group_ids          = ["${data.terraform_remote_state.core_prod_vpc.jenkins_security_group}", "${aws_security_group.backend_security_group.id}"]
}

#module "chqbook_api_4" {
#    source                      = "../../../modules/ec2"
#    name                        = "${var.chqbook_api_server_name}_4"
#    instance_type               = "${var.chqbook_api_instance_type}"
#    subnet_id                   = "${data.terraform_remote_state.core_prod_vpc.app_subnet_a_id}"
#    number_of_instances         = "${var.number_of_instances}"
#    key_name                    = "${var.prod_key_pair_name}"
#    associate_public_ip_address = "false"
#    user_data                   = ""
#    iam_instance_profile        = "jenkins_s3_full_Access"
#    zone_id                     = "${data.terraform_remote_state.core_prod_vpc.route53_zone_id}"
#    ami_id                      = "ami-0de5b62aa7ffa49f2"
#    root_volume_type            = "${var.api_root_volume_type}"
#    root_volume_size            = "${var.api_root_volume_size}"
#    security_group_ids          = ["${data.terraform_remote_state.core_prod_vpc.jenkins_security_group}", "${aws_security_group.backend_security_group.id}"]
#}

module "chqbook-api-tg" {
  source                = "../../../modules/targetgroup"
  target_group_name     = "api"
  backend_port          = "80"
  backend_protocol      = "HTTP"
  vpc_id                = "${data.terraform_remote_state.core_prod_vpc.vpc_id}"
  health_check_interval = "10"
  health_check_path     = "/hc"
  health_check_port     = "traffic-port"
  health_check_timeout  = "5"
  health_check_matcher  = "200-301"
  target_type           = "instance"
}

module "internal_alb_api_listener_rule_120" {
  source           = "../../../modules/alb_listener_rule"
  listener_arn     = "${data.terraform_remote_state.frontend.internal_alb_listener_arn}"
  priority         = "120"
  target_group_arn = "${module.chqbook-api-tg.arn}"
  host-header      = "api.chqbook.com"
}

module "internal_alb_rule_listener_rule_http" {
  source           = "../../../modules/alb_listener_rule"
  listener_arn     = "${data.terraform_remote_state.frontend.internal_alb_listener_arn}"
  priority         = "300"
  target_group_arn = "${module.chqbook-api-tg.arn}"
  host-header      = "api.internal.prod.com"
}

# module "internal_alb_api_listener_rule_210" {
#   source           = "../../../modules/alb_listener_rule"
#   listener_arn     = "${data.terraform_remote_state.frontend.internal_https_alb_listener_arn}"
#   priority         = "210"
#   target_group_arn = "${module.chqbook-api-tg.arn}"
#   host-header      = "api.uat2.chqbook.com"
# }

module "api1_tg_register" {
  source           = "../../../modules/targetgroup_attachment"
  target_group_arn = "${module.chqbook-api-tg.arn}"
  instance_id      = "${module.chqbook_api_1.id[0]}"
}

module "api2_tg_register" {
  source           = "../../../modules/targetgroup_attachment"
  target_group_arn = "${module.chqbook-api-tg.arn}"
  instance_id      = "${module.chqbook_api_2.id[0]}"
}

module "api3_tg_register" {
  source           = "../../../modules/targetgroup_attachment"
  target_group_arn = "${module.chqbook-api-tg.arn}"
  instance_id      = "${module.chqbook_api_3.id[0]}"
}

#module "api4_tg_register" {
#  source           = "../../../modules/targetgroup_attachment"
#  target_group_arn = "${module.chqbook-api-tg.arn}"
#  instance_id      = "${module.chqbook_api_4.id[0]}"
#}
resource "aws_route53_record" "rule" {
  zone_id = "${data.terraform_remote_state.core_prod_vpc.route53_zone_id}"
  name    = "api.${var.route53_zone_name}"
  type    = "A"

  alias {
    name                   = "${data.terraform_remote_state.core_prod_vpc.internal_alb_dns_name}"
    zone_id                = "${var.loadbalancer_zone_id}"
    evaluate_target_health = true
  }
}
