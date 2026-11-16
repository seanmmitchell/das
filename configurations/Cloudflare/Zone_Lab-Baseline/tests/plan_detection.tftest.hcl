# Mock all provider operations; never call Cloudflare.
mock_provider "cloudflare" {}

variables {
  cloudflare_user_email       = "ci@example.com"
  cloudflare_global_api_token = "ci-placeholder"
  cloudflare_zone_id          = "00000000000000000000000000000000"
}

run "free_plan" {
  command = plan
  override_data {
    target = data.cloudflare_zone.target
    values = { id = "00000000000000000000000000000000", plan = "free" }
  }
  assert {
    condition     = [local.zoneHasEnt, local.zoneHasBiz, local.zoneHasPro] == [false, false, false]
    error_message = "Free zones must not enable paid-plan settings."
  }
}

run "pro_plan" {
  command = plan
  override_data {
    target = data.cloudflare_zone.target
    values = { id = "00000000000000000000000000000000", plan = "pro" }
  }
  assert {
    condition     = [local.zoneHasEnt, local.zoneHasBiz, local.zoneHasPro] == [false, false, true]
    error_message = "Pro zones must enable only Pro-level settings."
  }
}

run "pro_plus_plan" {
  command = plan
  override_data {
    target = data.cloudflare_zone.target
    values = { id = "00000000000000000000000000000000", plan = "pro_plus" }
  }
  assert {
    condition     = [local.zoneHasEnt, local.zoneHasBiz, local.zoneHasPro] == [false, false, true]
    error_message = "Pro Plus zones must enable Pro-level settings."
  }
}

run "business_plan" {
  command = plan
  override_data {
    target = data.cloudflare_zone.target
    values = { id = "00000000000000000000000000000000", plan = "business" }
  }
  assert {
    condition     = [local.zoneHasEnt, local.zoneHasBiz, local.zoneHasPro] == [false, true, true]
    error_message = "Business zones must enable Business and Pro-level settings."
  }
}

run "enterprise_plan" {
  command = plan
  override_data {
    target = data.cloudflare_zone.target
    values = { id = "00000000000000000000000000000000", plan = "enterprise" }
  }
  assert {
    condition     = [local.zoneHasEnt, local.zoneHasBiz, local.zoneHasPro] == [true, true, true]
    error_message = "Enterprise zones must enable all plan levels."
  }
}
