variable "ami_id" {
  description = "The ID of the AMI to run in the cluster. Change this to your AMI ID."
  type        = string
  default     = "ami-0e832ce851fbcebda"
}

variable "cluster_name" {
  description = "What to name the Consul cluster and all of its associated resources"
  type        = string
  default     = "efi-hashi"
}

variable "num_servers" {
  description = "The number of Consul server nodes to deploy. We strongly recommend using 3 or 5."
  type        = number
  default     = 1
}

variable "cluster_tag_key" {
  description = "The tag the EC2 Instances will look for to automatically discover each other and form a cluster."
  type        = string
  default     = "new-cluster"
}

variable "ssh_key_name" {
  description = "The name of an EC2 Key Pair that can be used to SSH to the EC2 Instances in this cluster. Set to an empty string to not associate a Key Pair."
  type        = string
  default     = "eFishery"
}

variable "vpc_id" {
  description = "The ID of the VPC in which the nodes will be deployed.  Uses default VPC if not supplied."
  type        = string
  default     = null
}

variable "consul_service_linked_role_suffix" {
  description = "Suffix for the aws_iam_service_linked_role created for the consul cluster auto scaling group to use"
  type        = string
  default     = "consul-service-linked-role"
}
