terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}

resource "aws_iam_service_linked_role" "consul_asg_role" {
  aws_service_name = "autoscaling.amazonaws.com"
  custom_suffix    = var.consul_service_linked_role_suffix
  description      = "Service-Linked Role enables access to AWS Services and Resources used or managed by Auto Scaling"
}

module "consul_servers" {
  source = "git::git@github.com:hashicorp/terraform-aws-consul.git//modules/consul-cluster?ref=v0.7.4"

  cluster_name            = "${var.cluster_name}-server"
  cluster_size            = var.num_servers
  instance_type           = "t2.micro"
  service_linked_role_arn = aws_iam_service_linked_role.consul_asg_role.arn

  cluster_tag_key   = var.cluster_tag_key
  cluster_tag_value = var.cluster_name

  ami_id    = var.ami_id
  user_data = data.template_file.user_data_server.rendered

  vpc_id     = data.aws_vpc.default.id
  subnet_ids = data.aws_subnet_ids.default.ids

  allowed_ssh_cidr_blocks = ["0.0.0.0/0"]

  allowed_inbound_cidr_blocks = ["0.0.0.0/0"]
  ssh_key_name                = var.ssh_key_name

  tags = [
    {
      key                 = "Environment"
      value               = "development"
      propagate_at_launch = true
    }
  ]
}

data "template_file" "user_data_server" {
  template = file("${path.module}/user-data-server.sh")

  vars = {
    cluster_tag_key   = var.cluster_tag_key
    cluster_tag_value = var.cluster_name
  }
}

data "aws_vpc" "default" {
  default = var.vpc_id == null ? true : false
  id      = var.vpc_id
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_region" "current" {
}
