terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  version = "~> 2.0"
  region  = "ap-southeast-1"
}

resource "aws_kms_key" "vault" {
  description = "Vault KMS key"
}

module "vault_cluster" {
  source = "github.com/hashicorp/terraform-aws-vault.git//modules/vault-cluster?ref=v0.13.7"

  cluster_name  = var.vault_cluster_name
  cluster_size  = var.vault_cluster_size
  instance_type = var.vault_instance_type

  ami_id    = var.ami_id
  user_data = data.template_file.user_data_vault_cluster.rendered

  vpc_id     = data.aws_vpc.default.id
  subnet_ids = data.aws_subnet_ids.default.ids

  enable_auto_unseal = true

  auto_unseal_kms_key_arn = aws_kms_key.vault.arn

  allowed_ssh_cidr_blocks              = ["0.0.0.0/0"]
  allowed_inbound_cidr_blocks          = ["0.0.0.0/0"]
  allowed_inbound_security_group_ids   = []
  allowed_inbound_security_group_count = 0
  ssh_key_name                         = var.ssh_key_name
}

module "consul_iam_policies_servers" {
  source = "github.com/hashicorp/terraform-aws-consul.git//modules/consul-iam-policies?ref=v0.7.4"

  iam_role_id = module.vault_cluster.iam_role_id
}

data "template_file" "user_data_vault_cluster" {
  template = file("${path.module}/user-data-vault.sh")

  vars = {
    consul_cluster_tag_key   = "${var.consul_cluster_name}-servers"
    consul_cluster_tag_value = var.consul_cluster_name
    kms_key_id               = aws_kms_key.vault.arn
    aws_region               = data.aws_region.current.name
  }
}

module "security_group_rules" {
  source = "github.com/hashicorp/terraform-aws-consul.git//modules/consul-client-security-group-rules?ref=v0.7.4"

  security_group_id = module.vault_cluster.security_group_id

  allowed_inbound_cidr_blocks = ["0.0.0.0/0"]
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
