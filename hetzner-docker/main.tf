module "jupyterlab" {
  source    = "../modules/jupyterlab"

  instance_type  = "cx11"
  private_key_path = "./hetzhub"
}
