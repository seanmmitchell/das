//// Cloudflare Explicit API Credentials
/*variable "cloudflare_api_token" {
  description = "Cloudflare API Token (Key)"
  type = string
  sensitive = true
}
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}*/

//// Cloudflare Global API Credentials
variable "cloudflare_user_email" {
  description = "Cloudflare User Email"
  type        = string
}

variable "cloudflare_global_api_token" {
  description = "Cloudflare User Global API Key"
  type        = string
  sensitive   = true
}

//// Target Zone
variable "cloudflare_zone_id" {
  description = "Cloudflare Zone (ID) to Target"
  type        = string
}

//// Get Zone Plan
data "cloudflare_zone" "target" {
  zone_id = var.cloudflare_zone_id
}

//// Plan IDs
// From: https://github.com/cloudflare/terraform-provider-cloudflare/blob/d4ef0830489859f70d0b8cf2208a51bd908731d6/internal/sdkv2provider/resource_cloudflare_zone.go
// planIDPro        = "pro"
// planIDProPlus    = "pro_plus"
// planIDBusiness   = "business"
// planIDEnterprise = "enterprise"

locals {
  zoneHasEnt = data.cloudflare_zone.target.plan == "enterprise"
  zoneHasBiz = local.zoneHasEnt || data.cloudflare_zone.target.plan == "business"
  zoneHasPro = local.zoneHasBiz || contains(["pro_plus", "pro"], data.cloudflare_zone.target.plan)
}
