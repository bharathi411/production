output "admin_1_private_ip" {
  description = "Ouput private IP of the created chqbook_api's server"
  value = "${module.chqbook_admin_1.private_ip}"
}

output "admin_2_private_ip" {
  description = "Ouput private IP of the created chqbook_api's server"
  value = "${module.chqbook_admin_2.private_ip}"
}

#output "admin_3_private_ip" {
#  description = "Ouput private IP of the created chqbook_api's server"
#  value = "${module.chqbook_admin_3.private_ip}"
#}

#output "admin_4_private_ip" {
#  description = "Ouput private IP of the created chqbook_api's server"
#  value = "${module.chqbook_admin_4.private_ip}"
#}
output "admin_tg_arn" {
  value = "${module.chqbook-admin-tg.arn}"
}
