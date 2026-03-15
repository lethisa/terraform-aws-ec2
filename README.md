# terraform-aws-ec2-container

[![Terraform Registry](https://img.shields.io/badge/Terraform%20Registry-Module-blue.svg)](https://registry.terraform.io/modules/lethisa/ec2-container/aws)
[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.3-blueviolet.svg)](https://www.terraform.io)
[![AWS Provider](https://img.shields.io/badge/AWS-%3E%3D5.0-orange.svg)](https://registry.terraform.io/providers/hashicorp/aws)

Terraform module which deploys an **EC2 instance running a Docker container** using `user_data` and `systemd`.

This module creates:

- EC2 instance
- Security group
- IAM role and instance profile
- Docker container startup configuration

## Usage

```hcl
module "ec2_container" {
  source           = "lethisa/ec2/aws"
  version          = 1.1.0
  vpc_id           = "vpc-xxxx"
  instance_type    = "t3.micro"
  key_name         = "my-keypair"
  root_volume_size = 10

  environment = {
    name             = "dev"
    background_color = "blue"
    container_image  = "swinkler/tia-webserver"
    container_name   = "web"
    container_port   = 80
    host_port        = 8080
    allowed_cidr     = "0.0.0.0/0"
  }
}
```

## Examples

A complete working example can be found in:

```bash
examples/basic
```

This example deploys a small EC2 instance that runs a Docker container and exposes the application via the configured `host_port`.

<!-- markdownlint-disable MD033 -->
<!-- markdownlint-disable MD060 -->
<!-- BEGIN_TF_DOCS -->

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_instance_sg"></a> [instance\_sg](#module\_instance\_sg) | terraform-aws-modules/security-group/aws | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.ec2_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_instance.instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_iam_policy_document.ec2_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ec2_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Configuration for the application environment and container runtime settings | <pre>object({<br/>    name             = string<br/>    background_color = string<br/>    container_image  = string<br/>    container_name   = string<br/>    container_port   = number<br/>    host_port        = number<br/>    allowed_cidr     = string<br/>  })</pre> | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | EC2 instance type | `string` | n/a | yes |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | Existing AWS key pair name | `string` | n/a | yes |
| <a name="input_root_volume_size"></a> [root\_volume\_size](#input\_root\_volume\_size) | Root volume size in GB | `number` | `10` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC where the instance will be deployed | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_url"></a> [app\_url](#output\_app\_url) | n/a |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | n/a |
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | n/a |
<!-- END_TF_DOCS -->

<!-- markdownlint-enable MD033 -->
<!-- markdownlint-enable MD060 -->

## Architecture

The module provisions the following components:

```bash
Internet
   │
Security Group (host_port)
   │
EC2 Instance
   │
Docker Container
   │
Application
```

The EC2 instance installs Docker during startup and launches the configured container using a `systemd` service.

## License

MIT Licensed. See the `LICENSE` file for full details.
