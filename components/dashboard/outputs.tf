output "dashboard_1_private_ip" {
  description = "Ouput private IP of the created chqbook_dashboard's server"
  value = "${module.chqbook_dashboard_1.private_ip}"
}

output "dashboard_2_private_ip" {
  description = "Ouput private IP of the created chqbook_dashboard's server"
  value = "${module.chqbook_dashboard_2.private_ip}"
}

output "dashboard_3_private_ip" {
  description = "Ouput private IP of the created chqbook_dashboard's server"
  value = "${module.chqbook_dashboard_3.private_ip}"
}

output "dashboard_4_private_ip" {
  description = "Ouput private IP of the created chqbook_dashboard's server"
  value = "${module.chqbook_dashboard_4.private_ip}"
}
output "dashboard_tg_arn" {
  value = "${module.chqbook-dashboard-tg.arn}"
}

output "dashboard1_id" {
  value = "${module.chqbook_dashboard_1.id}"
}

output "dashboard2_id" {
  value = "${module.chqbook_dashboard_2.id}"
}

#output "dashboard3_id" {
#  value = "${module.chqbook_dashboard_3.id}"
#}
#
#output "dashboard4_id" {
#  value = "${module.chqbook_dashboard_4.id}"
#}