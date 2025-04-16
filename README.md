# akeyless-terraform

## Select Akeyless auth method for terraform provider
```
provider "akeyless" {
  api_gateway_address = "https://api.akeyless.io"

  api_key_login {
    access_id  = ""
    access_key = ""
  }

  //  aws_iam_login {
  //    access_id = ""
  //  }

  //  azure_ad_login {
  //    access_id = ""
  //  }

  //  email_login {
  //    admin_email = "user@mail.com"
  //    admin_password = ""
  //  }

  // jwt_login {
  //    access_id = ""
  //    jwt = var.jwt
  //    // OR provide your JWT by storing it in an environment variable called AKEYLESS_AUTH_JWT
  // }
}
```

## Create terraform 
### Define variables in variables.tf and set the values in terrafrom.tfvars
### Define output 

## Execution
###  Init
```
$ cd provider/
$ ls -al
total 32
drwxr-xr-x  6 waynezhu  staff   192 Mar 28 16:00 .
drwxr-xr-x  6 waynezhu  staff   192 Mar 28 16:02 ..
-rw-r--r--  1 waynezhu  staff  1323 Mar 28 16:00 main.tf
-rw-r--r--  1 waynezhu  staff   130 Mar 28 16:00 output.tf
-rw-r--r--  1 waynezhu  staff   236 Mar 28 16:00 terraform.tfvars
-rw-r--r--  1 waynezhu  staff   436 Mar 28 16:00 variables.tf

$ terraform init
Initializing the backend...
Initializing provider plugins...
- Finding latest version of hashicorp/local...
- Finding akeyless-community/akeyless versions matching ">= 1.0.0"...
- Installing hashicorp/local v2.5.2...
- Installed hashicorp/local v2.5.2 (signed by HashiCorp)
- Installing akeyless-community/akeyless v1.8.2...
- Installed akeyless-community/akeyless v1.8.2 (self-signed, key ID EEA698E7ACFEAB58)
Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://www.terraform.io/docs/cli/plugins/signing.html
Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

### Plan
```
$ terraform plan -out tf.plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # akeyless_associate_role_auth_method.api_to_role will be created
  + resource "akeyless_associate_role_auth_method" "api_to_role" {
      + am_name        = (known after apply)
      + case_sensitive = "true"
      + id             = (known after apply)
      + role_name      = "/devops/tf/demo-acces-role"
    }

  # akeyless_auth_method_api_key.api_key will be created
  + resource "akeyless_auth_method_api_key" "api_key" {
      + access_expires    = 0
      + access_id         = (known after apply)
      + access_key        = (sensitive value)
      + delete_protection = "false"
      + id                = (known after apply)
      + jwt_ttl           = 0
      + name              = "/devops/tf/auth-method-api-key"
    }

  # akeyless_role.role will be created
  + resource "akeyless_role" "role" {
      + delete_protection = "false"
      + id                = (known after apply)
      + name              = "/devops/tf/demo-acces-role"

      + rules {
          + capability = [
              + "list",
              + "read",
            ]
          + path       = "/devops/*"
          + rule_type  = "auth-method-rule"
        }
    }

  # akeyless_static_secret.secret will be created
  + resource "akeyless_static_secret" "secret" {
      + format            = "text"
      + id                = (known after apply)
      + multiline_value   = false
      + path              = "/devops/tf/static_secret"
      + protection_key    = (known after apply)
      + secure_access_web = (known after apply)
      + type              = "generic"
      + value             = (sensitive value)
      + version           = (known after apply)
    }

  # akeyless_target_db.postgres_target will be created
  + resource "akeyless_target_db" "postgres_target" {
      + db_name   = "test"
      + db_type   = "postgres"
      + host      = "35.238.87.113"
      + id        = (known after apply)
      + name      = "/devops/tf/postgres_target"
      + port      = "5432"
      + pwd       = "mypassword"
      + ssl       = false
      + user_name = "test"
    }

  # local_file.api_key_file will be created
  + resource "local_file" "api_key_file" {
      + content              = (sensitive value)
      + content_base64sha256 = (known after apply)
      + content_base64sha512 = (known after apply)
      + content_md5          = (known after apply)
      + content_sha1         = (known after apply)
      + content_sha256       = (known after apply)
      + content_sha512       = (known after apply)
      + directory_permission = "0777"
      + file_permission      = "0777"
      + filename             = "./api_key_output.json"
      + id                   = (known after apply)
    }

Plan: 6 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + api_key = (sensitive value)

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Saved the plan to: tf.plan

To perform exactly these actions, run the following command to apply:
    terraform apply "tf.plan"
```

### Apply
```
$ terraform apply "tf.plan"
akeyless_target_db.postgres_target: Creating...
akeyless_auth_method_api_key.api_key: Creating...
akeyless_static_secret.secret: Creating...
akeyless_target_db.postgres_target: Creation complete after 0s [id=/devops/tf/postgres_target]
akeyless_auth_method_api_key.api_key: Creation complete after 1s [id=/devops/tf/auth-method-api-key]
akeyless_role.role: Creating...
local_file.api_key_file: Creating...
local_file.api_key_file: Creation complete after 0s [id=f85eeaa92257cdecd9307347fe5ed2c314032000]
akeyless_static_secret.secret: Creation complete after 1s [id=/devops/tf/static_secret]
akeyless_role.role: Creation complete after 0s [id=/devops/tf/demo-acces-role]
akeyless_associate_role_auth_method.api_to_role: Creating...
akeyless_associate_role_auth_method.api_to_role: Creation complete after 0s [id=ass-9y8lyk36e9fjv0c1lrk8]

Apply complete! Resources: 6 added, 0 changed, 0 destroyed.

Outputs:

api_key = <sensitive>
```