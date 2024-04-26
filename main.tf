terraform {
  required_version = ">= 1.3.6"
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.89.0"
    }
  }
}

// NOTE: YOU NEED ACCOUNTADMIN ROLE TO RUN THE MODULE
//provider "snowflake" {
//  role = "ACCOUNTADMIN"
//}

data "snowflake_system_generate_scim_access_token" "scim" {
  integration_name = var.idp
}

resource "snowflake_saml_integration" "saml_integration" {
  name                       = "saml_integration"
  saml2_provider             = var.saml2_provider
  saml2_issuer               = var.saml2_issuer
  saml2_sso_url              = var.saml2_sso_url
  saml2_x509_cert            = var.saml2_x509_cert
  saml2_snowflake_acs_url    = var.saml2_snowflake_acs_url
  saml2_snowflake_issuer_url = var.saml2_snowflake_issuer_url
  enabled                    = var.enabled
}

resource "snowflake_role" "provisioner" {
  name = "${upper(var.idp)}_PROVISIONER"
}

resource "snowflake_account_grant" "provisioner_create_user" {
  depends_on = [snowflake_role.provisioner]
  privilege  = "CREATE USER"
  roles      = [snowflake_role.provisioner.name]
}

resource "snowflake_account_grant" "provisioner_create_role" {
  depends_on = [snowflake_role.provisioner]
  privilege  = "CREATE ROLE"
  roles      = [snowflake_role.provisioner.name]
}

resource "snowflake_role_grants" "provisioner_grants" {
  depends_on = [snowflake_role.provisioner]
  role_name  = snowflake_role.provisioner.name

  roles = [
    "ACCOUNTADMIN",
  ]
}

resource "snowflake_scim_integration" "scim_integration" {
  depends_on = [snowflake_saml_integration.saml_integration]

  name             = upper(snowflake_role.provisioner.name)
  provisioner_role = snowflake_role.provisioner.name
  scim_client      = upper(var.idp)
}
