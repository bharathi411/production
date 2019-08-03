output "chqbook_api_1_server_private_ip" {
  description = "Ouput private IP of the created chqbook_api's server"
  value = "${module.chqbook_api_1.private_ip}"
}

output "chqbook_api_2_server_private_ip" {
  description = "Ouput private IP of the created chqbook_api's server"
  value = "${module.chqbook_api_2.private_ip}"
}

output "chqbook_api_3_server_private_ip" {
  description = "Ouput private IP of the created chqbook_api's server"
  value = "${module.chqbook_api_2.private_ip}"
}

#output "chqbook_api_4_server_private_ip" {
#  description = "Ouput private IP of the created chqbook_api's server"
#  value = "${module.chqbook_api_2.private_ip}"
#}

output "api_tg_arn" {
  value = "${module.chqbook-api-tg.arn}"
}
