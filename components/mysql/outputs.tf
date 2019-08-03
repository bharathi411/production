output "chqbook_mysql_m_server_private_ip" {
  description = "Ouput private IP of the created mysql master server"
  value = "${module.mysql_server_master.private_ip}"
}

output "chqbook_mysql_s_server_private_ip" {
  description = "Ouput private IP of the created mysql slave server"
  value = "${module.mysql_server_slave.private_ip}"
}
