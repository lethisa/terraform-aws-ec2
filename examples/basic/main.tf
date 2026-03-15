terraform {
  required_version = ">= 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

data "aws_vpc" "default" {
  default = true
}

module "ec2_container" {
  source = "../../"

  vpc_id           = data.aws_vpc.default.id
  instance_type    = "t3.micro"
  key_name         = "my-keypair"
  root_volume_size = 10

  environment = {
    name             = "dev"
    background_color = "green"
    container_image  = "swinkler/tia-webserver"
    container_name   = "web"
    container_port   = 80
    host_port        = 8080
    allowed_cidr     = "0.0.0.0/0"
  }
}