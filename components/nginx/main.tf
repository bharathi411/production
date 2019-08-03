provider "aws" {
  region  = "${var.region}"
  profile = "${var.profile}"
}

resource "aws_security_group" "proxy_security_group" {
  name        = "proxy_security_group"
  vpc_id      = "${data.terraform_remote_state.core_prod_vpc.vpc_id}"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${data.terraform_remote_state.core_prod_vpc.external_alb_sg_id}"]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = ["${data.terraform_remote_state.core_prod_vpc.external_alb_sg_id}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags {
      Name = "proxy_security_group"
  }
}

module "nginx_instance_1" {
    source                      = "../../../modules/ec2"
    name                        = "${var.nginx_server_name}_1"
    instance_type               = "${var.nginx_instance_type}"
    subnet_id                   = "${data.terraform_remote_state.core_prod_vpc.app_subnet_a_id}"
    number_of_instances         = "${var.number_of_instances}"
    key_name                    = "${var.prod_key_pair_name}"
    associate_public_ip_address = "false"
    user_data                   = ""
    iam_instance_profile        = "EC2_S3_ReadOnly"
    zone_id                     = "${data.terraform_remote_state.core_prod_vpc.route53_zone_id}"
    ami_id                      = "${var.nginx_ami_id}"
    root_volume_type            = "${var.nginx_root_volume_type}"
    root_volume_size            = "${var.nginx_root_volume_size}"
    security_group_ids          = ["${data.terraform_remote_state.core_prod_vpc.jenkins_security_group}", "${aws_security_group.proxy_security_group.id}"]
}

module "nginx_instance_2" {
    source                      = "../../../modules/ec2"
    name                        = "${var.nginx_server_name}_2"
    instance_type               = "${var.nginx_instance_type}"
    subnet_id                   = "${data.terraform_remote_state.core_prod_vpc.app_subnet_b_id}"
    number_of_instances         = "${var.number_of_instances}"
    key_name                    = "${var.prod_key_pair_name}"
    associate_public_ip_address = "false"
    user_data                   = ""
    iam_instance_profile        = "EC2_S3_ReadOnly"
    zone_id                     = "${data.terraform_remote_state.core_prod_vpc.route53_zone_id}"
    ami_id                      = "${var.nginx_ami_id}"
    root_volume_type            = "${var.nginx_root_volume_type}"
    root_volume_size            = "${var.nginx_root_volume_size}"
    security_group_ids          = ["${data.terraform_remote_state.core_prod_vpc.jenkins_security_group}", "${aws_security_group.proxy_security_group.id}"]
}

module "nginx-tg" {
  source                = "../../../modules/targetgroup"
  target_group_name     = "prod-nginx-tg"
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

module "nginx-https-tg" {
  source                = "../../../modules/targetgroup"
  target_group_name     = "prod-nginx-https-tg"
  backend_port          = "443"
  backend_protocol      = "HTTPS"
  vpc_id                = "${data.terraform_remote_state.core_prod_vpc.vpc_id}"
  health_check_interval = "10"
  health_check_path     = "/"
  health_check_port     = "traffic-port"
  health_check_timeout  = "5"
  health_check_matcher  = "200-301"
  target_type           = "instance"
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = "${data.terraform_remote_state.core_prod_vpc.external_alb_arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_302"
    }
  }
}

# module "external_alb_listener" {
#   source            = "../../../modules/alb_listener"
#   load_balancer_arn = "${data.terraform_remote_state.core_prod_vpc.external_alb_arn}"
#   port              = "80"
#   protocol          = "HTTP"
#   target_group_arn  = "${module.nginx-tg.arn}"
# }

module "external_https_alb_listener" {
  source            = "../../../modules/alb_listener_https"
  load_balancer_arn = "${data.terraform_remote_state.core_prod_vpc.external_alb_arn}"
  port              = "443"
  protocol          = "HTTPS"
  target_group_arn  = "${module.nginx-tg.arn}"
  certificate_arn   = "${var.certificate_arn}"
  security_policy   = "${var.security_policy}"
}

# module "external_alb_nginx_listener_rule_110" {
#   source           = "../../../modules/alb_listener_rule"
#   listener_arn     = "${module.external_alb_listener.arn}"
#   priority         = "160"
#   target_group_arn = "${module.nginx-tg.arn}"
#   host-header      = "uat2.chqbook.com"
# }

# module "external_alb_https_nginx_listener_rule_170" {
#   source           = "../../../modules/alb_listener_rule"
#   listener_arn     = "${module.external_https_alb_listener.arn}"
#   priority         = "170"
#   target_group_arn = "${module.nginx-tg.arn}"
#   host-header      = "uat2.chqbook.com"
# }

module "nginx1_tg_register" {
  source           = "../../../modules/targetgroup_attachment"
  target_group_arn = "${module.nginx-tg.arn}"
  instance_id      = "${module.nginx_instance_1.id[0]}"
}

module "nginx2_tg_register" {
  source           = "../../../modules/targetgroup_attachment"
  target_group_arn = "${module.nginx-tg.arn}"
  instance_id      = "${module.nginx_instance_2.id[0]}"
}

# module "nginx1_https_tg_register" {
#   source           = "../../../modules/targetgroup_attachment"
#   target_group_arn = "${module.nginx-tg.arn}"
#   instance_id      = "${module.nginx_instance_1.id[0]}"
# }

# module "nginx2_https_tg_register" {
#   source           = "../../../modules/targetgroup_attachment"
#   target_group_arn = "${module.nginx-tg.arn}"
#   instance_id      = "${module.nginx_instance_2.id[0]}"
# }
