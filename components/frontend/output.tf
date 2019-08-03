output "chqbook_frontend_1_server_private_ip" {
  description = "Ouput private IP of the created chqbook_frontend's server"
  value = "${module.chqbook_frontend_1.private_ip}"
}

output "chqbook_frontend_2_server_private_ip" {
  description = "Ouput private IP of the created chqbook_frontend's server"
  value = "${module.chqbook_frontend_2.private_ip}"
}

output "chqbook_frontend_3_server_private_ip" {
  description = "Ouput private IP of the created chqbook_frontend's server"
  value = "${module.chqbook_frontend_3.private_ip}"
}

#output "chqbook_frontend_4_server_private_ip" {
#  description = "Ouput private IP of the created chqbook_frontend's server"
#  value = "${module.chqbook_frontend_4.private_ip}"
#}

output "internal_alb_listener_arn" {
  value = "${module.internal_alb_listener.arn}"
}

# output "internal_https_alb_listener_arn" {
#   value = "${module.internal_https_alb_listener.arn}"
# }

output "frontent_tg_arn" {
  value = "${module.chqbook-frontend-tg.arn}"
}
