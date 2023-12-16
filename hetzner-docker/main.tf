module "jupyterlab-service" {
  source = "./module"

  instance_type  = "cx11"
  private_key_path = "./hetzhub"
  public_key_path = "./hetzhub.pub"
}
