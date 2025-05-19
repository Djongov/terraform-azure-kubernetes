# terraform-azure-template

This is the template for creating terraform Azure modules. If you want to create a new azure module, you can create a new repo and use this as the source template

## Terraform version

Terraform 1.10.5+

## Providers

AzureRM 4.14.0+
AzureAD 3.1.0+ (because of last-modified-by tag). If you remove data "azuread_user" "current_user", this provider will not be downloaded

## Resources created by this module (Example)

[azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group "azurerm_resource_group official docs")

## Example

Check [example](/example) folder

## Limitations

None

## To Do

None

## Repos using this tfmod

[tfmod-azure-template](https://github.com/UEFADigital/tfmod-azure-template "tfmod-azure-template")

## Variables

### Common variables

| **Variable**              | **Type**           | **Description**                                                                                                                                                              | **Required/Optional**                        |
|---------------------------|--------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------|
| `resource_group_name`     | `string`           | The name of the resource group, used for placing resources in the group. May come from module output or be set as a string.                                                  | Required                                    |
| `environment`             | `string`           | Specifies the environment for the application (e.g., `dev`, `prod`), used in naming and tagging resources.                                                                  | Required                                    |
| `subscription_id`         | `string`           | The subscription ID where the resources will be deployed, validated against the allowed list if provided.                                                                   | Required                                    |
| `location`                | `string`           | The geographic location where resources will be deployed, also used in naming and tagging. Defaults to `westeurope`.                                                        | Optional, defaults to `westeurope`          |
| `common_tags`             | `map(string)`      | Common tags to be applied to all resources.                                                                                                                                  | Optional, defaults to empty map             |

### Module specific variables
