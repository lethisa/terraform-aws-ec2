
module "instance_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "~> 5.0"
  name        = "${var.environment.name}-sg"
  description = "Security group for ${var.environment.name}"
  vpc_id      = var.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = var.environment.host_port
      to_port     = var.environment.host_port
      protocol    = "tcp"
      cidr_blocks = var.environment.allowed_cidr
    }
  ]

  egress_rules = ["all-all"]
}

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_role" {
  name               = "${var.environment.name}-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

data "aws_iam_policy_document" "ec2_policy" {
  statement {
    effect = "Allow"

    actions = [
      "logs:*",
      "ec2:DescribeInstances"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "policy" {
  name   = "${var.environment.name}-ec2-policy"
  role   = aws_iam_role.ec2_role.id
  policy = data.aws_iam_policy_document.ec2_policy.json
}

resource "aws_iam_instance_profile" "profile" {
  name = "${var.environment.name}-instance-profile"
  role = aws_iam_role.ec2_role.name
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  owners = ["099720109477"]
}

resource "aws_instance" "instance" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [module.instance_sg.security_group_id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.profile.name

  user_data = base64encode(
    templatefile("${path.module}/templates/startup.sh", {
      NAME            = var.environment.name,
      BG_COLOR        = var.environment.background_color,
      CONTAINER_IMAGE = var.environment.container_image,
      CONTAINER_NAME  = var.environment.container_name,
      CONTAINER_PORT  = var.environment.container_port,
      HOST_PORT       = var.environment.host_port
    })
  )

  lifecycle {
    ignore_changes = [ami]
  }

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp3"
  }

  tags = {
    Name      = "${var.environment.name}-vm"
    ManagedBy = "Terraform"
  }

  metadata_options {
    http_tokens            = "required"
    instance_metadata_tags = "enabled"
  }
}