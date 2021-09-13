terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  version = "~> 2.70.0"
  region  = "ap-southeast-1"
}

module "nomad_servers" {
  source = "github.com/hashicorp/terraform-aws-nomad//modules/nomad-cluster?ref=v0.10.0"

  cluster_name  = "${var.nomad_cluster_name}-server"
  instance_type = "t2.micro"

  min_size         = var.num_nomad_servers
  max_size         = var.num_nomad_servers
  desired_capacity = var.num_nomad_servers

  ami_id    = var.ami_id
  user_data = data.template_file.user_data_nomad_server.rendered

  vpc_id     = data.aws_vpc.default.id
  subnet_ids = data.aws_subnet_ids.default.ids

  allowed_ssh_cidr_blocks = ["0.0.0.0/0"]

  allowed_inbound_cidr_blocks = ["0.0.0.0/0"]
  ssh_key_name                = var.ssh_key_name
}

module "consul_iam_policies_servers" {
  source = "github.com/hashicorp/terraform-aws-consul//modules/consul-iam-policies?ref=v0.11.0"

  iam_role_id = module.nomad_servers.iam_role_id
}

data "template_file" "user_data_nomad_server" {
  template = file("${path.module}/user-data-nomad-server.sh")

  vars = {
    num_servers       = var.num_nomad_servers
    cluster_tag_key   = var.cluster_tag_key
    cluster_tag_value = var.consul_cluster_name
  }
}

module "nomad_clients" {
  source = "github.com/hashicorp/terraform-aws-nomad//modules/nomad-cluster?ref=v0.10.0"

  cluster_name  = "${var.nomad_cluster_name}-client"
  instance_type = "t2.micro"

  cluster_tag_key   = "nomad-clients"
  cluster_tag_value = var.nomad_cluster_name

  min_size         = var.num_nomad_clients
  max_size         = var.num_nomad_clients
  desired_capacity = var.num_nomad_clients
  ami_id           = var.ami_id
  user_data        = data.template_file.user_data_nomad_client.rendered
  vpc_id           = data.aws_vpc.default.id
  subnet_ids       = data.aws_subnet_ids.default.ids

  allowed_ssh_cidr_blocks     = ["0.0.0.0/0"]
  allowed_inbound_cidr_blocks = ["0.0.0.0/0"]
  ssh_key_name                = var.ssh_key_name
  ebs_block_devices = [
    {
      "device_name" = "/dev/xvde"
      "volume_size" = "10"
    },
  ]
}

module "consul_iam_policies_clients" {
  source = "github.com/hashicorp/terraform-aws-consul//modules/consul-iam-policies?ref=v0.11.0"

  iam_role_id = module.nomad_clients.iam_role_id
}

data "template_file" "user_data_nomad_client" {
  template = file("${path.module}/user-data-nomad-client.sh")

  vars = {
    cluster_tag_key   = var.cluster_tag_key
    cluster_tag_value = var.consul_cluster_name
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_region" "current" {
}
