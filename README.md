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

## Vault

To build the Vault AMI, run the following command from the `vault` directory:

```
packer build vault.json
```

Once the AMI is done building, you can add the AMI ID to the `variables.tf` file and run the following:

```
terraform init
terraform plan
terraform apply
```

## Initialize Vault

To initialize Vault for the first time, execute the following commands:

```
export VAULT_ADDR=https://127.0.0.1:8200
vault status
vault operator init -recovery-shares=1 -recovery-threshold=1
```

**Don't lose your initial root token.**

## Questions?

Open an issue.
