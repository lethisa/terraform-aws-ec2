variable "environment" {
  description = "Configuration for the application environment and container runtime settings"

  type = object({
    name             = string
    background_color = string
    container_image  = string
    container_name   = string
    container_port   = number
    host_port        = number
    allowed_cidr     = string
  })
}

variable "vpc_id" {
  description = "VPC where the instance will be deployed"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "Existing AWS key pair name"
  type        = string
}

variable "root_volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 10
}

variable "enable_ssh" {
  type    = bool
  default = false
}