output "chqbook_redis_server_private_ip" {
  description = "Ouput private IP of the created redis server"
  value = "${module.redis_server.private_ip}"
}
