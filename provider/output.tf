output "api_key" {
  value       = akeyless_auth_method_api_key.api_key
  description = "the API key JSON."
  sensitive = true
}

