# Variables

variable "cloudflare_api_token" {
  type        = string
  description = "Cloudflare API token."
}

variable "cloudflare_zone_main" {
  type        = string
  description = "Cloudflare zone of choice."
}

variable "cloudflare_record_main" {
  type        = string
  description = "The name of the DNS record that will be created and updated."
}

variable "qazx_ip_addr" {
  type        = string
  description = "The public IP of this server. This will be automatically created and updated!"
  default     = "0.0.0.0"
}
