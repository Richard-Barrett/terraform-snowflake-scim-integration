output "scim_access_token" {
  value       = data.snowflake_system_generate_scim_access_token.scim.access_token
  description = "The SCIM access token"
  sensitive   = true
}
