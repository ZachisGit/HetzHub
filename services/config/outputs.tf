output "zone_id" {
  value = var.zone_id
}

data "template_file" "zone_id" {
    template = var.zone_id
}

output "hetzner_dns_auth_token" {
  value = var.hetzner_dns_auth_token
}

data "template_file" "hetzner_dns_auth_token" {
    template = var.hetzner_dns_auth_token
}

output "provider_token" {
  value = var.provider_token
}

data "template_file" "provider_token" {
    template = var.provider_token
}

data "template_file" "service-id" {
    template = "config"
}

output "service-id" {
    value = "config"
}