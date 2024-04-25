
variable "idp" {
  description = "The identity provider. Can be 'okta' or 'ms_azure'"
  type        = string
}

variable "saml2_provider" {
  type        = string
  default     = "default_saml2_provider"
  description = "value to enable or disable the SAML integration"
}

variable "saml2_issuer" {
  type        = string
  default     = "your_default_value_here"
  description = "value to enable or disable the SAML integration"
}

variable "saml2_snowflake_acs_url" {
  type        = string
  default     = "https://example.com/saml2/acs"
  description = "value to enable or disable the SAML integration"
}

variable "saml2_x509_cert" {
  type        = string
  default     = "default_value"
  description = "value to enable or disable the SAML integration"
  sensitive   = true
}

variable "saml2_sso_url" {
  type        = string
  default     = "https://example.com/saml2/sso"
  description = "value to enable or disable the SAML integration"
}

variable "saml2_snowflake_issuer_url" {
  type        = string
  default     = "https://example.com/snowflake/issuer"
  description = "value to enable or disable the SAML integration"
}

variable "enabled" {
  type        = bool
  default     = true
  description = "value to enable or disable the SAML integration"
}
