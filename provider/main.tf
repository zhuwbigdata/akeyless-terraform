terraform {
  required_providers {
    akeyless = {
      version = ">= 1.0.0"
      source  = "akeyless-community/akeyless"
    }
  }
}

provider "akeyless" {
    api_gateway_address = var.api_gateway_address

    api_key_login {
        access_id  = var.access_id
        access_key = var.access_key
    }
}

resource "akeyless_static_secret" "secret" {
    path = "/devops/tf/static_secret"
    value = var.secret
}

resource "akeyless_auth_method_api_key" "api_key" {
  name = "/devops/tf/auth-method-api-key"
}

# Save the output to a local file
resource "local_file" "api_key_file" {
  content  = jsonencode(akeyless_auth_method_api_key.api_key)
  filename = "${path.module}/api_key_output.json"
}

resource "akeyless_role" "role" {
  depends_on = [
    akeyless_auth_method_api_key.api_key
  ]
  name = "/devops/tf/demo-acces-role"

  rules {
    capability = ["read","list"]
    path = "/devops/*"
    rule_type = "auth-method-rule"
  }
}

resource "akeyless_associate_role_auth_method" "api_to_role" {
  am_name = akeyless_auth_method_api_key.api_key.id
  role_name = akeyless_role.role.name
}


resource "akeyless_target_db" "postgres_target" {
  name = "/devops/tf/postgres_target"
  db_type = "postgres"
  user_name = "test"
	host = "35.238.87.113"
	pwd = "mypassword"
	port = "5432"
	db_name = "test"
}
    
  