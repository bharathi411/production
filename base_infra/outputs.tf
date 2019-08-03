output "vpc_id" {
  description = "Ouput ID of the created VPC"
  value = "${module.vpc.vpc_id}"
}
output "vpc_id" {
  description = "Ouput ID of the created VPC"
  value = "${module.vpc.vpc_id}"
}

output "route53_zone_id" {
  description = "Ouput ID of the created Route53 zone"
  value = "${module.vpc.route53_zone_name}"
}

output "internet_gateway_id" {
  description = "Internet Gateway ID of VPC"
  value = "${module.vpc.internet_gateway_id}"
}

output "public_subnet_a_id" {
  description = "Ouput ID of the created Public Subnet AZA"
  value = "${module.vpc.public_subnet_aza_id}"
}

output "public_subnet_b_id" {
  description = "Ouput ID of the created Public Subnet AZB"
  value = "${module.vpc.public_subnet_azb_id}"
}

output "app_subnet_a_id" {
  description = "Ouput ID of the created Private Subnet AZA"
  value = "${module.vpc.private_subnet_aza_id}"
}

output "app_subnet_b_id" {
  description = "Ouput ID of the created Private Subnet AZB"
  value = "${module.vpc.private_subnet_azb_id}"
}

output "db_subnet_a_id" {
  description = "Ouput ID of the created Db Subnet AZB"
  value = "${module.db_sub_a.id}"
}

output "db_subnet_b_id" {
  description = "Ouput ID of the created Db Subnet AZB"
  value = "${module.db_sub_b.id}"
}

output "management_subnet_b_id" {
  description = "Ouput ID of the created Management Subnet AZB"
  value = "${module.management_sub_a.id}"
}

output "private_route_table_id" {
  description = "Ouput ID of the created Private Route Table"
  value = "${module.vpc.private_route_table_id}"
}

output "public_route_table_id" {
  description = "Ouput ID of the created Private Route Table"
  value = "${module.vpc.public_route_table_id}"
}

output "nat_gateway_id" {
  description = "Output ID of the created nat gateway"
  value = "${module.vpc.nat_gateway_id}"
}

output "vpc_peering_id" {
  description = "Output ID of the VPC peering"
  value = "${module.vpc_peering.aws_peering_id}"
}

output "external_alb_arn" {
  value = "${module.vpc.external_loadbalancer_arn}"
}

output "external_alb_dns_name" {
  value = "${module.vpc.external_loadbalancer_dns_name}"
}

output "external_alb_id" {
  value = "${module.vpc.external_loadbalancer_id}"
}

output "internal_alb_arn" {
  value = "${module.vpc.internal_loadbalancer_arn}"
}

output "internal_alb_dns_name" {
  value = "${module.vpc.internal_loadbalancer_dns_name}"
}

output "internal_alb_id" {
  value = "${module.vpc.internal_loadbalancer_id}"
}

# output "internal-default-tg-arn" {
#   value = "${module.internal-default-tg.arn}"
# }

# output "nginx-tg-arn" {
#   value = "${module.nginx-tg.arn}"
# }

# output "chqbook-admin-tg-arn" {
#   value = "${module.chqbook-admin-tg.arn}"
# }

# output "chqbook-frontend-tg-arn" {
#   value = "${module.chqbook-frontend-tg.arn}"
# }

# output "chqbook-dashboard-tg-arn" {
#   value = "${module.chqbook-dashboard-tg.arn}"
# }

# output "chqbook-api-tg-arn" {
#   value = "${module.chqbook-api-tg.arn}"
# }

# output "chqbook-sso-tg-arn" {
#   value = "${module.chqbook-sso-tg.arn}"
# }

# output "chqbook-metro-tg-arn" {
#   value = "${module.chqbook-metro-tg.arn}"
# }

output "bastion_server_public_ip" {
  description = "Ouput public IP of the created bastion's server"
  value = "${module.vpc.openvpn_public_ip}"
}

output "internal_alb_sg_id" {
  value = "${module.vpc.web_security_group_id}"
}

output "external_alb_sg_id" {
  value = "${module.vpc.web_security_group_id}"
}

output "bastion_security_group_id" {
  value = "${module.vpc.openvpn_security_group_id}"
}

# output "internal_alb_listener_arn" {
#   value = "${module.internal_alb_listener.arn}"
# }

# output "external_alb_listener_arn" {
#   value = "${module.external_alb_listener.arn}"
# }

# output "admin_tg_arn" {
#   value = "${module.chqbook-admin-tg.arn}"
# }

# output "frontend_tg_arn" {
#   value = "${module.chqbook-frontend-tg.arn}"
# }

# output "dashboard_tg_arn" {
#   value = "${module.chqbook-dashboard-tg.arn}"
# }

# output "api_tg_arn" {
#   value = "${module.chqbook-api-tg.arn}"
# }

# output "rule_engine_arn" {
#   value = "${module.chqbook-rules-tg.arn}"
# }

# output "sso_arn" {
#   value = "${module.chqbook-sso-tg.arn}"
# }

# output "metro_arn" {
#   value = "${module.chqbook-metro-tg.arn}"
# }

output "jenkins_security_group" {
  value = "${aws_security_group.jenkins_ssh_security.id}"
}

output "alb_security_group" {
  value = "${aws_security_group.alb_security_group.id}"
}

output "db_security_group" {
  value = "${aws_security_group.db_security_group.id}"
}
