output "app_url" {
  value = "http://${module.ec2_container.public_ip}:8080"
}