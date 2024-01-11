terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.44.1"
    }    
    remote = {
      source = "tenstad/remote"
      version = "0.1.2"
    }
    time = {
      source = "hashicorp/time"
      version = "0.10.0"
    }
  }
}