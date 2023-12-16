resource "hcloud_ssh_key" "hetzhub_key" {
  name       = "HetzHub SSH keys"
  public_key = file("${var.private_key_path}")
}

resource "hcloud_server" "node" {
  name        = "node"
  image       = var.image
  server_type = var.instance_type
  location    = var.region
  ssh_keys    = [hcloud_ssh_key.hetzhub_key.id]
}

resource "null_resource" "server" {
  depends_on = [hcloud_server.node]

    provisioner "remote-exec" {
        inline = [
            "sudo apt-get update",
            "sudo apt-get install -y docker.io",
            "sudo apt-get install -y docker-compose-plugin",
            "mkdir -p ${var.app_dir}",
        ]

        connection {
            type        = "ssh"
            user        = var.user_name
            private_key = file("${var.private_key_path}")
            host        = hcloud_server.node.ipv4_address
        }
    }
  
    lifecycle {
        create_before_destroy = true
    }
}


# ----------- VARIABLES -------------
variable "user_name" {
    type    = string
    default = "root"
}

variable "private_key_path" {
    type    = string
}

variable "image" {
    type    = string
    default = "ubuntu-22.04"
}

variable "instance_type" {
    type    = string
    default = "cx11"
}

variable "region" {
    type    = string
    description = "nbg1, fsn1, hel1, ash or hil"
    default = "fsn1"
}

variable "app_dir" {
    type    = string
    default = "/hetzhub/apps"  
}