output "instance_id" {
  value = aws_instance.instance.id
}

output "public_ip" {
  value = aws_instance.instance.public_ip
}

output "app_url" {
  value = "http://${aws_instance.instance.public_ip}:${var.environment.host_port}"
}