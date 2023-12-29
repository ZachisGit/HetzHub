terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.44.1"
    }
  }
}

variable provider_token {
  type = string
  default = "my-token"
}

provider "hcloud" {
  token = "my-token"
}
