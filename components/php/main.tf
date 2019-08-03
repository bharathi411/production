provider "aws" {
  region  = "${var.region}"
  profile = "${var.profile}"
}

resource "aws_security_group" "chqbook_php_security_group" {
  name        = "chqbook_php_security_group"
  vpc_id      = "${data.terraform_remote_state.core_prod_vpc.vpc_id}"

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${data.terraform_remote_state.core_prod_vpc.bastion_security_group_id}"]
  }

  ingress {
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    security_groups = ["${data.terraform_remote_state.core_prod_vpc.internal_alb_sg_id}"]
  }

  ingress {
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    security_groups = ["${data.terraform_remote_state.nginx.nginx_security_group_id}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
      Name = "chqbook_php_security_group"
  }
}

module "chqbook_php_1" {
    source                      = "../../../modules/ec2"
    name                        = "${var.chqbook_php_server_name}_1"
    instance_type               = "${var.chqbook_php_instance_type}"
    subnet_id                   = "${data.terraform_remote_state.core_prod_vpc.app_subnet_a_id}"
    number_of_instances         = "${var.number_of_instances}"
    key_name                    = "${var.prod_key_pair_name}"
    associate_public_ip_address = "false"
    user_data                   = ""
    iam_instance_profile        = "jenkins_s3_full_Access"
    zone_id                     = "${data.terraform_remote_state.core_prod_vpc.route53_zone_id}"
    ami_id                      = "${var.chqbook_php_ami_id}"
    root_volume_type            = "${var.php_root_volume_type}"
    root_volume_size            = "${var.php_root_volume_size}"
    security_group_ids          = ["${data.terraform_remote_state.core_prod_vpc.jenkins_security_group}", "${aws_security_group.chqbook_php_security_group.id}"]
}

module "chqbook_php_2" {
    source                      = "../../../modules/ec2"
    name                        = "${var.chqbook_php_server_name}_2"
    instance_type               = "${var.chqbook_php_instance_type}"
    subnet_id                   = "${data.terraform_remote_state.core_prod_vpc.app_subnet_b_id}"
    number_of_instances         = "${var.number_of_instances}"
    key_name                    = "${var.prod_key_pair_name}"
    associate_public_ip_address = "false"
    user_data                   = ""
    iam_instance_profile        = "jenkins_s3_full_Access"
    zone_id                     = "${data.terraform_remote_state.core_prod_vpc.route53_zone_id}"
    ami_id                      = "${var.chqbook_php_ami_id}"
    root_volume_type            = "${var.php_root_volume_type}"
    root_volume_size            = "${var.php_root_volume_size}"
    security_group_ids          = ["${data.terraform_remote_state.core_prod_vpc.jenkins_security_group}", "${aws_security_group.chqbook_php_security_group.id}"]
}

#module "chqbook_php_3" {
#    source                      = "../../../modules/ec2"
#    name                        = "${var.chqbook_php_server_name}_3"
#    instance_type               = "${var.chqbook_php_instance_type}"
#    subnet_id                   = "${data.terraform_remote_state.core_prod_vpc.app_subnet_b_id}"
#    number_of_instances         = "${var.number_of_instances}"
#    key_name                    = "${var.prod_key_pair_name}"
#    associate_public_ip_address = "false"
#    user_data                   = ""
#    iam_instance_profile        = "jenkins_s3_full_Access"
#    zone_id                     = "${data.terraform_remote_state.core_prod_vpc.route53_zone_id}"
#    ami_id                      = "ami-066512112f836eef1"
#    root_volume_type            = "${var.php_root_volume_type}"
#    root_volume_size            = "${var.php_root_volume_size}"
#    security_group_ids          = ["${data.terraform_remote_state.core_prod_vpc.jenkins_security_group}", "${aws_security_group.chqbook_php_security_group.id}"]
#}

#module "chqbook_php_4" {
#    source                      = "../../../modules/ec2"
#    name                        = "${var.chqbook_php_server_name}_4"
#    instance_type               = "${var.chqbook_php_instance_type}"
#    subnet_id                   = "${data.terraform_remote_state.core_prod_vpc.app_subnet_b_id}"
#    number_of_instances         = "${var.number_of_instances}"
#    key_name                    = "${var.prod_key_pair_name}"
#    associate_public_ip_address = "false"
#    user_data                   = ""
#    iam_instance_profile        = "jenkins_s3_full_Access"
#    zone_id                     = "${data.terraform_remote_state.core_prod_vpc.route53_zone_id}"
#    ami_id                      = "ami-066512112f836eef1"
#    root_volume_type            = "${var.php_root_volume_type}"
#    root_volume_size            = "${var.php_root_volume_size}"
#    security_group_ids          = ["${data.terraform_remote_state.core_prod_vpc.jenkins_security_group}", "${aws_security_group.chqbook_php_security_group.id}"]
#}

module "chqbook-php-tg" {
  source                = "../../../modules/targetgroup"
  target_group_name     = "php"
  backend_port          = "8000"
  backend_protocol      = "HTTP"
  vpc_id                = "${data.terraform_remote_state.core_prod_vpc.vpc_id}"
  health_check_interval = "10"
  health_check_path     = "/"
  health_check_port     = "traffic-port"
  health_check_timeout  = "5"
  health_check_matcher  = "200-301"
  target_type           = "instance"
}

module "internal_alb_php_listener_rule_120" {
  source           = "../../../modules/alb_listener_rule"
  listener_arn     = "${data.terraform_remote_state.frontend.internal_alb_listener_arn}"
  priority         = "190"
  target_group_arn = "${module.chqbook-php-tg.arn}"
  host-header      = "agent.uat2.chqbook.com"
}

module "internal_alb_rule_listener_rule_http" {
  source           = "../../../modules/alb_listener_rule"
  listener_arn     = "${data.terraform_remote_state.frontend.internal_alb_listener_arn}"
  priority         = "290"
  target_group_arn = "${module.chqbook-php-tg.arn}"
  host-header      = "agent.internal.prod.com"
}

#module "internal_alb_php_listener_rule_250" {
#  source           = "../../../modules/alb_listener_rule"
#  listener_arn     = "${data.terraform_remote_state.frontend.internal_https_alb_listener_arn}"
#  priority         = "250"
#  target_group_arn = "${module.chqbook-php-tg.arn}"
#  host-header      = "agent.uat2.chqbook.com"
#}

module "php1_tg_register" {
  source           = "../../../modules/targetgroup_attachment"
  target_group_arn = "${module.chqbook-php-tg.arn}"
  instance_id      = "${module.chqbook_php_1.id[0]}"
}

module "php2_tg_register" {
  source           = "../../../modules/targetgroup_attachment"
  target_group_arn = "${module.chqbook-php-tg.arn}"
  instance_id      = "${module.chqbook_php_2.id[0]}"
}

#module "php3_tg_register" {
#  source           = "../../../modules/targetgroup_attachment"
#  target_group_arn = "${module.chqbook-php-tg.arn}"
#  instance_id      = "${module.chqbook_php_3.id[0]}"
#}
#
#module "php4_tg_register" {
#  source           = "../../../modules/targetgroup_attachment"
#  target_group_arn = "${module.chqbook-php-tg.arn}"
#  instance_id      = "${module.chqbook_php_4.id[0]}"
#}

resource "aws_route53_record" "rule" {
  zone_id = "${data.terraform_remote_state.core_prod_vpc.route53_zone_id}"
  name    = "agent.${var.route53_zone_name}"
  type    = "A"

  alias {
    name                   = "${data.terraform_remote_state.core_prod_vpc.internal_alb_dns_name}"
    zone_id                = "${var.loadbalancer_zone_id}"
    evaluate_target_health = true
  }
}
