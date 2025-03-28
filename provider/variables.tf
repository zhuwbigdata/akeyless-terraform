# variables.tf

variable "api_gateway_address" {
  description = "Akeyless API Gateway address"
  type        = string
}

variable "access_id" {
  description = "Akeyless Access ID"
  type        = string
  sensitive   = true
}

variable "access_key" {
  description = "Akeyless Access Key"
  type        = string
  sensitive   = true
}

variable "secret" {
  description = "Static Secret"
  type        = string
  sensitive   = true
}
