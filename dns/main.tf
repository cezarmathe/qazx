# Update a Cloudflare DNS record that points to a dynamic IP address.

terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 2.0"
    }
  }
  required_version = ">= 0.13"
}

# Cloudflare provider configuration.
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# The Cloudflare zone.
resource "cloudflare_zone" "main" {
  zone = var.cloudflare_zone_main
}

# The Cloudflare DNS record.
resource "cloudflare_record" "main" {
  zone_id = cloudflare_zone.main.id
  name    = var.cloudflare_record_main
  value   = var.qazx_ip_addr
  type    = "A"
  ttl     = 1
  proxied = false
}
