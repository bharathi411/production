provider "aws" {
  region  = "${var.region}"
  profile = "${var.profile}"
}

resource "aws_security_group" "chqbook_frontend_security_group" {
  name        = "chqbook_frontend_security_group"
  vpc_id      = "${data.terraform_remote_state.core_prod_vpc.vpc_id}"
  
  ingress {
    from_port       = 4200
    to_port         = 4200
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
      Name = "chqbook_frontend_security_group"
  }
}

module "chqbook_frontend_1" {
    source                      = "../../../modules/ec2"
    name                        = "${var.chqbook_frontend_server_name}_1"
    instance_type               = "${var.chqbook_frontend_instance_type}"
    subnet_id                   = "${data.terraform_remote_state.core_prod_vpc.app_subnet_a_id}"
    number_of_instances         = "${var.number_of_instances}"
    key_name                    = "${var.prod_key_pair_name}"
    associate_public_ip_address = "false"
    user_data                   = ""
    iam_instance_profile        = "jenkins_s3_full_Access"
    zone_id                     = "${data.terraform_remote_state.core_prod_vpc.route53_zone_id}"
    ami_id                      = "${var.chqbook_frontend_ami_id}"
    root_volume_type            = "${var.frontend_root_volume_type}"
    root_volume_size            = "${var.frontend_root_volume_size}"
    security_group_ids          = ["${aws_security_group.chqbook_frontend_security_group.id}", "${data.terraform_remote_state.core_prod_vpc.jenkins_security_group}"]
    ebs_optimized               = "false"
}

module "chqbook_frontend_2" {
    source                      = "../../../modules/ec2"
    name                        = "${var.chqbook_frontend_server_name}_2"
    instance_type               = "${var.chqbook_frontend_instance_type}"
    subnet_id                   = "${data.terraform_remote_state.core_prod_vpc.app_subnet_b_id}"
    number_of_instances         = "${var.number_of_instances}"
    key_name                    = "${var.prod_key_pair_name}"
    associate_public_ip_address = "false"
    user_data                   = ""
    iam_instance_profile        = "jenkins_s3_full_Access"
    zone_id                     = "${data.terraform_remote_state.core_prod_vpc.route53_zone_id}"
    ami_id                      = "${var.chqbook_frontend_ami_id}"
    root_volume_type            = "${var.frontend_root_volume_type}"
    root_volume_size            = "${var.frontend_root_volume_size}"
    security_group_ids          = ["${aws_security_group.chqbook_frontend_security_group.id}", "${data.terraform_remote_state.core_prod_vpc.jenkins_security_group}"]
    ebs_optimized               = "false"
}

module "chqbook_frontend_3" {
    source                      = "../../../modules/ec2"
    name                        = "${var.chqbook_frontend_server_name}_3"
    instance_type               = "${var.chqbook_frontend_instance_type}"
    subnet_id                   = "${data.terraform_remote_state.core_prod_vpc.app_subnet_b_id}"
    number_of_instances         = "${var.number_of_instances}"
    key_name                    = "${var.prod_key_pair_name}"
    associate_public_ip_address = "false"
    user_data                   = ""
    iam_instance_profile        = "jenkins_s3_full_Access"
    zone_id                     = "${data.terraform_remote_state.core_prod_vpc.route53_zone_id}"
    ami_id                      = "ami-036c4682cb4fa0670"
    root_volume_type            = "${var.frontend_root_volume_type}"
    root_volume_size            = "${var.frontend_root_volume_size}"
    security_group_ids          = ["${aws_security_group.chqbook_frontend_security_group.id}", "${data.terraform_remote_state.core_prod_vpc.jenkins_security_group}"]
    ebs_optimized               = "false"
}

#module "chqbook_frontend_4" {
#    source                      = "../../../modules/ec2"
#    name                        = "${var.chqbook_frontend_server_name}_4"
#    instance_type               = "${var.chqbook_frontend_instance_type}"
#    subnet_id                   = "${data.terraform_remote_state.core_prod_vpc.app_subnet_b_id}"
#    number_of_instances         = "${var.number_of_instances}"
#    key_name                    = "${var.prod_key_pair_name}"
#    associate_public_ip_address = "false"
#    user_data                   = ""
#    iam_instance_profile        = "jenkins_s3_full_Access"
#    zone_id                     = "${data.terraform_remote_state.core_prod_vpc.route53_zone_id}"
#    ami_id                      = "ami-036c4682cb4fa0670"
#    root_volume_type            = "${var.frontend_root_volume_type}"
#    root_volume_size            = "${var.frontend_root_volume_size}"
#    security_group_ids          = ["${aws_security_group.chqbook_frontend_security_group.id}", "${data.terraform_remote_state.core_prod_vpc.jenkins_security_group}"]
#    ebs_optimized               = "false"
#}

module "chqbook-frontend-tg" {
  source                = "../../../modules/targetgroup"
  target_group_name     = "frontend"
  backend_port          = "4200"
  backend_protocol      = "HTTP"
  vpc_id                = "${data.terraform_remote_state.core_prod_vpc.vpc_id}"
  health_check_interval = "10"
  health_check_path     = "/"
  health_check_port     = "traffic-port"
  health_check_timeout  = "5"
  health_check_matcher  = "200-301"
  target_type           = "instance"
}

module "internal_alb_listener" {
  source            = "../../../modules/alb_listener"
  load_balancer_arn = "${data.terraform_remote_state.core_prod_vpc.internal_alb_arn}"
  port              = "80"
  protocol          = "HTTP"
  target_group_arn  = "${module.chqbook-frontend-tg.arn}"
}

# module "internal_https_alb_listener" {
#   source            = "../../../modules/alb_listener_https"
#   load_balancer_arn = "${data.terraform_remote_state.core_prod_vpc.internal_alb_arn}"
#   port              = "443"
#   protocol          = "HTTPS"
#   target_group_arn  = "${module.chqbook-frontend-tg.arn}"
#   certificate_arn   = "${var.certificate_arn}"
#   security_policy   = "${var.security_policy}"
# }

module "internal_alb_frontend_listener_rule_100" {
  source           = "../../../modules/alb_listener_rule"
  listener_arn     = "${module.internal_alb_listener.arn}"
  priority         = "100"
  target_group_arn = "${module.chqbook-frontend-tg.arn}"
  host-header      = "frontend.uat2.chqbook.com"
}

module "internal_alb_rule_listener_rule_http" {
  source           = "../../../modules/alb_listener_rule"
  listener_arn     = "${module.internal_alb_listener.arn}"
  priority         = "230"
  target_group_arn = "${module.chqbook-frontend-tg.arn}"
  host-header      = "frontend.internal.prod.com"
}

# module "internal_alb_frontend_listener_rule_230" {
#   source           = "../../../modules/alb_listener_rule"
#   listener_arn     = "${module.internal_https_alb_listener.arn}"
#   priority         = "230"
#   target_group_arn = "${module.chqbook-frontend-tg.arn}"
#   host-header      = "frontend.uat2.chqbook.com"
# }

module "frontend1_tg_register" {
  source           = "../../../modules/targetgroup_attachment"
  target_group_arn = "${module.chqbook-frontend-tg.arn}"
  instance_id      = "${module.chqbook_frontend_1.id[0]}"
}

module "frontend2_tg_register" {
  source           = "../../../modules/targetgroup_attachment"
  target_group_arn = "${module.chqbook-frontend-tg.arn}"
  instance_id      = "${module.chqbook_frontend_2.id[0]}"
}

module "frontend3_tg_register" {
  source           = "../../../modules/targetgroup_attachment"
  target_group_arn = "${module.chqbook-frontend-tg.arn}"
  instance_id      = "${module.chqbook_frontend_3.id[0]}"
}

#module "frontend4_tg_register" {
#  source           = "../../../modules/targetgroup_attachment"
#  target_group_arn = "${module.chqbook-frontend-tg.arn}"
#  instance_id      = "${module.chqbook_frontend_4.id[0]}"
#}

resource "aws_route53_record" "rule" {
  zone_id = "${data.terraform_remote_state.core_prod_vpc.route53_zone_id}"
  name    = "frontend.${var.route53_zone_name}"
  type    = "A"

  alias {
    name                   = "${data.terraform_remote_state.core_prod_vpc.internal_alb_dns_name}"
    zone_id                = "${var.loadbalancer_zone_id}"
    evaluate_target_health = true
  }
}
