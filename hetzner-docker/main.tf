# Main templat file HetzHub
resource "tls_private_key" "ssh_key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

resource "hcloud_ssh_key" "hetzhub_key" {
    name       = "HetzHub SSH keys"
    public_key = tls_private_key.ssh_key.public_key_openssh
}

module "global_config"{
  source = "../services/config"
 
  provider_token = "MY_PROVIDER_TOKEN"
  zone_id = "MY_ZONE_ID (only for custom toplevel domain)"
  hetzner_dns_auth_token = "MY_HETZNER_DNS_AUTH_TOKEN (only for custom hetzner dns api token)"
}


module "jupyterlab-service" {
  source = "../services/jupyterlab"
  provider_token = module.global_config.provider_token
  private_key = tls_private_key.ssh_key.private_key_pem
  public_key = tls_private_key.ssh_key.public_key_pem
  hcloud_key_id = hcloud_ssh_key.hetzhub_key.id
  zone_id = module.global_config.zone_id
  hetzner_dns_auth_token = module.global_config.hetzner_dns_auth_token

  # User Input
  app_name = "jupyterlab"
  instance_type  = "cpx11"
  enable_backups = true
  delete_protection = false
}

module "s3" {
  source = "../services/s3"
  provider_token = module.global_config.provider_token
  private_key = tls_private_key.ssh_key.private_key_pem
  public_key = tls_private_key.ssh_key.public_key_pem
  hcloud_key_id = hcloud_ssh_key.hetzhub_key.id
  zone_id = module.global_config.zone_id
  hetzner_dns_auth_token = module.global_config.hetzner_dns_auth_token

  # User Input
  app_name = "s3"
  instance_type = "cpx11"
  enable_backups = true
  delete_protection = false
  volume_size = 100
}