# terraform-aws-hashistack

This repository will show you how to provision a Consul+Vault+Nomad Cluster.

This has been tested with `Terraform v0.12.28` and `Packer 1.6.0`.


## Consul

To build the Consul AMI, run the following command from the `consul` directory:

```
packer build consul.json
```

Once the AMI is done building, you can add the AMI ID to the `variables.tf` file and run the following:

```
terraform init
terraform plan
terraform apply
```

## Questions?

Open an issue.
