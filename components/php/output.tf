output "chqbook_php_1_server_private_ip" {
  description = "Ouput private IP of the created chqbook_php's server"
  value = "${module.chqbook_php_1.private_ip}"
}

output "chqbook_php_2_server_private_ip" {
  description = "Ouput private IP of the created chqbook_php's server"
  value = "${module.chqbook_php_2.private_ip}"
}

#output "chqbook_php_3_server_private_ip" {
#  description = "Ouput private IP of the created chqbook_php's server"
#  value = "${module.chqbook_php_3.private_ip}"
#}

output "chqbook_php_tg_arn" {
  value = "${module.chqbook-php-tg.arn}"
}
