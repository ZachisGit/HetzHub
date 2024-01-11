terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.44.1"
    }
    tls = {
      source = "hashicorp/tls"
      version = "4.0.5"
    }
  }
}

data "template_file" "provider_token" {
  template = module.global_config.provider_token
}

provider "hcloud" {
  token = module.global_config.provider_token
}
