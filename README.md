<img align="right" width="60" height="60" src="images/terraform.png">

# tf-snowflake-scim-integration module

This is a repository that makes a `saml+scim` integration based on the ms_azure or okta integrations for Snowflake. The following resources are made depended on what you choose:

- snowflake_account_grant.provisioner_create_role
- snowflake_account_grant.provisioner_create_user
- snowflake_role.provisioner
- snowflake_role_grants.provisioner_grants
- snowflake_saml_integration.saml_integration
- snowflake_scim_integration.scim_integration

Example CICD with `BitBucket` and `Codefresh`:
![Image](./images/diagram.png)

For further documentation on how this works, please read the following:

- [Azure SCIM Integration with Snowflake](https://docs.snowflake.com/en/user-guide/scim-azure)
- [Okta SCIM Integration with Snowflake](https://docs.snowflake.com/en/user-guide/scim-okta)

Essentially this module simplifies the ability to onboard new accounts and enables the IDP of choice to:

- Manage the user lifecycle (i.e. create, update, and delete) in Snowflake.
- Manage the role lifecycle (i.e. create, update, and delete) in Snowflake.
- Manage user to role assignments in Snowflake.

NOTES:

- THIS MODULE ASSUMES YOU HAVE AN IDP OF OKTA OR MS_AZURE
- THIS MODULE ASSUMES THAT YOU HAVE SET UP YOUR IDP AND THAT IT IS CONFIGURED
- THIS MODULE ASSUMES YOU HAVE SNOWFLAKE

WARNINGS:

- DO NOT HARDCODE THE `saml2_x509_cert` THIS IS A SENSITIVE VALUE, YOU SHOULD USE SOME OTHER METHOD TO GRAB THIS DATA, I SIMPLY SHOW WHAT THE DATA MUST LOOK LIKE. IT IS A SECURITY RISK TO HARDCODE YOUR `saml2_x509_cert` AND IS MARKED SENSITIVE BY DEFAULT
- THE `scim_token` IS DIRECTED TORWARDS SYSTEM OUTPUT ON INITAL CREATION AND WILL LOG TO YOUR TERMINAL ON CREATION FOR YOU TO USE. THIS WILL ONLY HAPPEN ONCE AND IT WILL NOT APPEAR IN SYSTEM LOGS AS IT IS MARKED SENSITIVE BY DEFAULT

## Usage

To use the module you will need to use the following:

```hcl
module "snowflake_samlscim_usdevelopment" {
  source  = "https://github.com/Richard-Barrett/terraform-snowflake-scim-integration"
  version = "0.0.1"
  
  idp                        = "okta"
  saml2_issuer               = "http://www.okta.com/<OKTA_ENTITY_ID>"
  saml2_sso_url              = "https://<YOURDOMAIN>.okta.com/app/snowflake/<OKTA_ENTITY_ID>/sso/saml"
  saml2_provider             = "OKTA"
  saml2_x509_cert            = "MIIDnjCCAoa...IGA..."
  saml2_snowflake_issuer_url = "https://<URI>.<AWS_REGION>.aws.snowflakecomputing.com"
  saml2_snowflake_acs_url    = "https://<FQDN>.snowflakecomputing.com/fed/login"
}
```

Required Values:

| Values         |
|----------------|
| idp |
| saml2_issuer |
| saml2_sso_url |
| saml2_provider |
| saml2_x509_cert |
| saml2_snowflake_issuer_url |
| saml2_snowflake_acs_url |

Once you run the following:

```
terraform init
terraform validate
terraform plan
terraform apply
```

You should see something similar to the following:

```bash
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

scim_token = <sensitive>
```

Take the `scim_token` and update your IDP with the API integration, afterwards, make sure you check what you want controlled by the provisioner:

- NOTE: ORDER MATTERS, CREATE THE API TOKEN AND TEST PROVISIONING FIRST BEFORE YOU SELECT WHAT THE PROVISIONING DOES IN THE IDP.

### Additonal Usages

What if you want to manage the SCIM Access for ms_azure?

```hcl
module "snowflake_samlscim_usdevelopment" {
  source  = "https://github.com/Richard-Barrett/terraform-snowflake-scim-integration"
  version = "0.0.1"

  idp                        = "aad"
  saml2_issuer               = "http://www.okta.com/<OKTA_ENTITY_ID>"
  saml2_sso_url              = "https://<YOURDOMAIN>.okta.com/app/snowflake/<OKTA_ENTITY_ID>/sso/saml"
  saml2_provider             = "AAD"
  saml2_x509_cert            = "MIIDnjCCAoa...IGA..."
  saml2_snowflake_issuer_url = "https://<URI>.<AWS_REGION>.aws.snowflakecomputing.com"
  saml2_snowflake_acs_url    = "https://<FQDN>.snowflakecomputing.com/fed/login"
}
```

If you want to keep the `saml2_x509_cert` secret pull it in as a data value from a secure datastore using your backend.

## Overview

In overview, this repository acts as a digestible module that allows you to create a warehouse, the warehouse role, and the warehouse grant.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.6 |
| <a name="requirement_snowflake"></a> [snowflake](#requirement\_snowflake) | ~> 0.89.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_snowflake"></a> [snowflake](#provider\_snowflake) | 0.89.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [snowflake_account_grant.provisioner_create_role](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/account_grant) | resource |
| [snowflake_account_grant.provisioner_create_user](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/account_grant) | resource |
| [snowflake_role.provisioner](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/role) | resource |
| [snowflake_role_grants.provisioner_grants](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/role_grants) | resource |
| [snowflake_saml_integration.saml_integration](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/saml_integration) | resource |
| [snowflake_scim_integration.scim_integration](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/scim_integration) | resource |
| [snowflake_system_generate_scim_access_token.scim](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/data-sources/system_generate_scim_access_token) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enabled"></a> [enabled](#input\_enabled) | value to enable or disable the SAML integration | `bool` | `true` | no |
| <a name="input_idp"></a> [idp](#input\_idp) | The identity provider. Can be 'okta' or 'ms\_azure' | `string` | n/a | yes |
| <a name="input_saml2_issuer"></a> [saml2\_issuer](#input\_saml2\_issuer) | value to enable or disable the SAML integration | `string` | `"your_default_value_here"` | no |
| <a name="input_saml2_provider"></a> [saml2\_provider](#input\_saml2\_provider) | value to enable or disable the SAML integration | `string` | `"default_saml2_provider"` | no |
| <a name="input_saml2_snowflake_acs_url"></a> [saml2\_snowflake\_acs\_url](#input\_saml2\_snowflake\_acs\_url) | value to enable or disable the SAML integration | `string` | `"https://example.com/saml2/acs"` | no |
| <a name="input_saml2_snowflake_issuer_url"></a> [saml2\_snowflake\_issuer\_url](#input\_saml2\_snowflake\_issuer\_url) | value to enable or disable the SAML integration | `string` | `"https://example.com/snowflake/issuer"` | no |
| <a name="input_saml2_sso_url"></a> [saml2\_sso\_url](#input\_saml2\_sso\_url) | value to enable or disable the SAML integration | `string` | `"https://example.com/saml2/sso"` | no |
| <a name="input_saml2_x509_cert"></a> [saml2\_x509\_cert](#input\_saml2\_x509\_cert) | value to enable or disable the SAML integration | `string` | `"default_value"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_scim_access_token"></a> [scim\_access\_token](#output\_scim\_access\_token) | The SCIM access token |
<!-- END_TF_DOCS -->
