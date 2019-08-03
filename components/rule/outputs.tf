output "chqbook_rule_1_server_private_ip" {
  description = "Ouput private IP of the created chqbook_rule's server"
  value = "${module.chqbook_rule_1.private_ip}"
}

output "chqbook_rule_2_server_private_ip" {
  description = "Ouput private IP of the created chqbook_rule's server"
  value = "${module.chqbook_rule_2.private_ip}"
}

#output "chqbook_rule_3_server_private_ip" {
#  description = "Ouput private IP of the created chqbook_rule's server"
#  value = "${module.chqbook_rule_3.private_ip}"
#}

#output "chqbook_rule_4_server_private_ip" {
#  description = "Ouput private IP of the created chqbook_rule's server"
#  value = "${module.chqbook_rule_4.private_ip}"
#}


output "rule_engine_arn" {
  value = "${module.chqbook-rules-tg.arn}"
}
