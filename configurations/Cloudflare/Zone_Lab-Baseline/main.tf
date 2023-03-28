terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "3.33.1"
    }
  }
}

//// Cloudflare Interface
provider "cloudflare" {
  email = var.cloudflare_user_email
  api_key = var.cloudflare_global_api_token
}

//// Settings
resource "cloudflare_zone_settings_override" "baseline" {
  zone_id = var.cloudflare_zone_id
  settings {

    // SSL
    ssl = "strict"
    security_level           = "medium"
    min_tls_version = "1.2"
    tls_1_3 = "on"
    opportunistic_encryption = "on"
    automatic_https_rewrites = "on"
    always_use_https         = "on"

    // Features
    privacy_pass = "on"
    http3 = "on"
    // zero_rtt = "on" Incompatible iwth TLS 1.3
    response_buffering = local.zoneHasEnt ? "on": null       // Requires Ent
    true_client_ip_header = local.zoneHasEnt ? "on": null    // Requires Ent
    websockets = "on"
    ip_geolocation = "on"
    
    
    // Security
    browser_check = "on"
    challenge_ttl            = 3600

    // Performance
    brotli                   = "on"
    mirage                   = local.zoneHasPro ? "on" : null        // Requires Pro
    rocket_loader            = "on"
    polish                   = local.zoneHasPro ? "lossless" : null  // Requires Pro
    webp                     = local.zoneHasPro ? "on" : null        // Requires Pro
    minify {
      css  = "on"
      js   = "on"
      html = "on"
    }
    security_header {
      enabled = true
    }
  }
}

//// Argo & Caching
resource "cloudflare_argo" "baseline" {
  zone_id        = var.cloudflare_zone_id
  tiered_caching = "on"
  smart_routing  = "on"
}

resource "cloudflare_tiered_cache" "baseline" {
  zone_id    = var.cloudflare_zone_id
  cache_type = "smart"
}