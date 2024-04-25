terraform {
  required_version = ">= 1.3.6"
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.75.0"
    }
  }
}

provider snowflake {}

module "snowflake_samlscim_canary_okta" {
  source = "../../"

  idp                        = "okta"
  saml2_issuer               = "http://www.okta.com/dsfsdjfndsjfnsdjf"
  saml2_sso_url              = "https://dsfsdjfndsjfnsdjf.okta.com/app/snowflake/dsfsdjfndsjfnsdjf/sso/saml"
  saml2_provider             = "OKTA"
  saml2_x509_cert            = "MIIDn...MA0GCSqGSIb3DQEBCw..."
  saml2_snowflake_issuer_url = "https://ts79435322.eu-west-2.aws.snowflakecomputing.com"
  saml2_snowflake_acs_url    = "https://mytestcanary.snowflakecomputing.com/fed/login"
}

module "snowflake_samlscim_canary_aad" {
  source = "../../"

  idp                        = "aad"
  saml2_issuer               = "http://www.okta.com/dsfsdjfndsjfnsdjf"
  saml2_sso_url              = "https://dsfsdjfndsjfnsdjf.okta.com/app/snowflake/dsfsdjfndsjfnsdjf/sso/saml"
  saml2_provider             = "AAD"
  saml2_x509_cert            = "MIIDn...MA0GCSqGSIb3DQEBCw..."
  saml2_snowflake_issuer_url = "https://ts79435322.eu-west-2.aws.snowflakecomputing.com"
  saml2_snowflake_acs_url    = "https://mytestcanary.snowflakecomputing.com/fed/login"
}
