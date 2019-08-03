output "nginx_server_1_private_ip" {
  description = "Ouput private IP of the created nginx's server"
  value = "${module.nginx_instance_1.private_ip}"
}

output "nginx_server_2_private_ip" {
  description = "Ouput private IP of the created nginx's server"
  value = "${module.nginx_instance_2.private_ip}"
}

output "nginx_security_group_id" {
  value = "${aws_security_group.proxy_security_group.id}"
}

output "nginx_tg_arn" {
  value = "${module.nginx-tg.arn}"
}

# output "external_alb_listener_arn" {
#   value = "${module.external_alb_listener.arn}"
# }

# output "external_https_alb_listener_arn" {
#   value = "${module.external_https_alb_listener.arn}"
# }
