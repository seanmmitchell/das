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
// Zone Cache Rules
resource "cloudflare_ruleset" "wordpress-cache-settings" {
  kind    = "zone"
  name    = "default"
  phase   = "http_request_cache_settings"
  zone_id = var.cloudflare_zone_id
  rules {
    action      = "set_cache_settings"
    description = "Caching for \"/wp-content/\""
    enabled     = true
    expression  = "(http.request.uri.path eq \"/wp-content/*\")"
    action_parameters {
      browser_ttl {
        default = 259200
        mode    = "override_origin"
      }
      edge_ttl {
        default = 86400
        mode    = "override_origin"
      }
      serve_stale {
        disable_stale_while_updating = true
      }
      cache = true
    }
  }
}

// Zone WAF Custom Rules
resource "cloudflare_ruleset" "wordpress-waf-settings" {
  kind    = "zone"
  name    = "default"
  phase   = "http_request_firewall_custom"
  zone_id = var.cloudflare_zone_id
  rules {
    action      = "skip"
    description = "BOTS | Allow Good Bots"
    enabled     = true
    expression  = "(cf.bot_management.verified_bot)"
    action_parameters {
      ruleset = "current"
    }
    logging {
      status = "enabled"
    }
  }
  rules {
    action      = "block"
    description = "WAF-ML | Block Attack Traffic"
    enabled     = true
    expression  = "(cf.waf.score le 5)"
  }
  rules {
    action      = "managed_challenge"
    description = "WAF-ML | Challenge Possible Attacks"
    enabled     = true
    expression  = "(cf.waf.score le 10)"
  }
  rules {
    action      = "block"
    description = "BOTS | Block Bots by Score"
    enabled     = true
    expression  = "(cf.bot_management.score le 5)"
  }
  rules {
    action      = "managed_challenge"
    description = "BOTS | Challenge Probable Bots"
    enabled     = true
    expression  = "(cf.bot_management.score le 20)"
  }
  rules {
    action      = "managed_challenge"
    description = "Query Challenge (Managed)"
    enabled     = true
    expression  = "(http.request.uri.query eq \"challenge=managed\")"
  }
  rules {
    action      = "js_challenge"
    description = "Query Challenge (JS)"
    enabled     = true
    expression  = "(http.request.uri.query eq \"challenge=js\")"
  }
  rules {
    action      = "block"
    description = "Query Action (Block)"
    enabled     = true
    expression  = "(http.request.uri.query eq \"action=block\")"
  }
}