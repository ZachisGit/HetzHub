terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.44.1"
    }
  }
}

provider "hcloud" {
  token = "pwOlAq72jQQ03ixm02QQpmj62H2Kx2aYpKEbjOdVtll28uAyIFpytobSzfW4P8pM"
}
