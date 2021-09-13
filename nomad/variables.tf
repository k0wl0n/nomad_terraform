variable "ami_id" {
  description = "The ID of the AMI to run in the cluster."
  type        = string
  default     = "ami-03513fb81226ed99b"
}

variable "nomad_cluster_name" {
  description = "What to name the Nomad cluster and all of its associated resources"
  type        = string
  default     = "new-nomad"
}

variable "consul_cluster_name" {
  description = "What to name the Consul cluster and all of its associated resources"
  type        = string
  default     = "new-consul"
}

variable "num_nomad_servers" {
  description = "The number of Nomad server nodes to deploy. We strongly recommend using 3 or 5."
  type        = number
  default     = 3
}

variable "num_nomad_clients" {
  description = "The number of Nomad client nodes to deploy. You can deploy as many as you need to run your jobs."
  type        = number
  default     = 3
}

variable "cluster_tag_key" {
  description = "The tag the Consul EC2 Instances will look for to automatically discover each other and form a cluster."
  type        = string
  default     = "new-consul-servers"
}

variable "ssh_key_name" {
  description = "The name of an EC2 Key Pair that can be used to SSH to the EC2 Instances in this cluster. Set to null to not associate a Key Pair."
  type        = string
  default     = "eFishery"
}
