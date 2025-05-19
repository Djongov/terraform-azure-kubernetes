# Example

cd to this directory. Examine the main.tf and dev.tfvars files. They are providing an example to directly deploy resources defined by this module.

## Version

Terraform 10.0.5

## Authentication

Just your az login or with service principal credentials via export:

```powershell
$Env:ARM_CLIENT_ID = ""
$Env:ARM_CLIENT_SECRET = ""
$Env:ARM_SUBSCRIPTION_ID = ""
$Env:ARM_TENANT_ID = ""
```

```bash
export ARM_CLIENT_ID=""
export ARM_CLIENT_SECRET = ""
export ARM_SUBSCRIPTION_ID = ""
export ARM_TENANT_ID = ""
```

## Terraform testing example

```hcl
terraform init
```

```hcl
terraform plan -var-file dev.tfvars -out dev.plan
```

```hcl
terraform apply "dev.plan"
```

```hcl
terraform destroy -var-file dev.tfvars
```

## Real life scenario

```hcl
terraform init
```

```hcl
terraform workspace new dev
```

```hcl
terraform workspace select dev
```

```hcl
terraform plan -out dev.plan -var-file dev.tfvars
```

```hcl
terraform apply "dev.plan"
```

```hcl
terraform destroy -var-file dev.tfvars
```
