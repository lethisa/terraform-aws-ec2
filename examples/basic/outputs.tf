output "app_url" {
  value = "http://${module.ec2_container.public_ip}:8080"
}

output "instance_id" {
  value = module.ec2_container.instance_id
}

output "public_ip" {
  value = module.ec2_container.public_ip
}