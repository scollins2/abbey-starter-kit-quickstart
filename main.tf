terraform {
  backend "http" {
    address        = "https://api.abbey.io/terraform-http-backend"
    lock_address   = "https://api.abbey.io/terraform-http-backend/lock"
    unlock_address = "https://api.abbey.io/terraform-http-backend/unlock"
    lock_method    = "POST"
    unlock_method  = "POST"
  }

  required_providers {
    abbey = {
      source = "abbeylabs/abbey"
      version = "0.2.6"
    }
  }
}

provider "abbey" {
  # Configuration options
  bearer_auth = var.abbey_token
}

/* Uncomment and update
resource "abbey_grant_kit" "abbey_demo_site" {
  name = "Abbey_Demo_Site"
  description = <<-EOT
    Grants access to Abbey's Demo Page.
  EOT

  workflow = {
    steps = [
      {
        reviewers = {
          one_of = ["replace-me@example.com"] # CHANGEME
        }
      }
    ]
  }

  policies = [
    { bundle = "github://replace-me-with-organization/replace-me-with-repo/policies" } # CHANGEME
  ]

  output = {
    # Replace with your own path pointing to where you want your access changes to manifest.
    # Path is an RFC 3986 URI, such as `github://{organization}/{repo}/path/to/file.tf`.
    location = "github://replace-me-with-organization/replace-me-with-repo/access.tf" # CHANGEME
    append = <<-EOT
      resource "abbey_demo" "grant_read_write_access" {
        permission = "read_write"
        email = "{{ .data.system.abbey.identities.abbey.email }}"
      }
    EOT
  }
}
*/


resource "abbey_grant_kit" "demo" {
  name = "demo"
  description = "demo access"

  workflow = {
    steps = [
      {
        reviewers = {
          one_of = [
            "collinssofia10@gmail.com"
          ]
        }
      }
    ]
  }

  policies = [
    {
      query = <<-EOT
        package common
        
        import data.abbey.functions
        
        allow[msg] {
          functions.expire_after("5m")
          msg := sprintf("granting access for %s", ["5m"])
        }
      EOT
    }
  ]

  output = {
    location = "github://scollins2/abbey-starter-kit-quickstart/access.tf"
    append = <<-EOT
      resource "abbey_demo" "grant_read_write_access" {
        permission = "read_write"
        email = "{{ .data.system.abbey.identities.abbey.email }}"
      }
    EOT
  }
}
