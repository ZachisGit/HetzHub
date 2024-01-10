resource "hcloud_ssh_key" "hetzhub_key" {
    name       = "HetzHub SSH keys"
    public_key = file("./hetzhub.pub")
}

module "jupyterlab-service" {
  source = "../services/jupyterlab"

  app_name = "jupyterlab"
  provider_token = var.provider_token
  instance_type  = "cpx11"
  private_key_path = "./hetzhub"
  hcloud_key_id = hcloud_ssh_key.hetzhub_key.id
  enable_backups = true
}

module "s3" {
  source = "../services/s3"

  app_name = "s3"
  provider_token = var.provider_token
  instance_type = "cpx11"
  private_key_path = "./hetzhub"
  hcloud_key_id = hcloud_ssh_key.hetzhub_key.id
  enable_backups = true
  volume_size = 100
  delete_protection = false  
}