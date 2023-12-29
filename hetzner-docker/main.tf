#module "jupyterlab-service" {
#  source = "../services/jupyterlab"
#
#  instance_type  = "cx11"
#  private_key_path = "./hetzhub"
#  public_key_path = "./hetzhub.pub"
#  enable_backups = false
#}

module "s3-service" {
  source = "../services/s3"

  instance_type  = "cx11"
  private_key_path = "./hetzhub"
  public_key_path = "./hetzhub.pub"
  volume_size = 10
  enable_backups = false
  provider_token = var.provider_token
}
