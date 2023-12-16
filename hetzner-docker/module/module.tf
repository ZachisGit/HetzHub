

resource "hcloud_ssh_key" "hetzhub_key" {
  name       = "HetzHub SSH keys"
  public_key = file("${var.public_key_path}")
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
            "mkdir -p /hetzhub",
            "mkdir -p ${var.app_dir}",
            "wget https://github.com/docker/compose/releases/download/v2.23.3/docker-compose-linux-x86_64 -O /hetzhub/docker-compose",
            "chmod +x /hetzhub/docker-compose",
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

resource "null_resource" "jupyterlab_setup" {
    depends_on = [null_resource.server]

    provisioner "remote-exec" {
        inline = [
            "mkdir -p ${var.app_dir}/jupyterlab ",
            "export ACCESS_TOKEN=\"${data.template_file.access_token.rendered}\"; export JUPYTER_PORT=${var.jupyter_port}; echo \"${file(var.compose_file_path)}\" > ${var.app_dir}/jupyterlab/app.yaml",
            "/hetzhub/docker-compose -f ${var.app_dir}/jupyterlab/app.yaml up -d",
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

// create random jupyterlab token and hold in variable
resource "random_password" "jupyterlab_token" {
  length           = 16
  special          = false
  override_special = "_%@"
}

// string variable that holds the jupyterlab token
data "template_file" "access_token" {
  template = random_password.jupyterlab_token.result
}


// ----------- VARIABLES -------------
variable "compose_file_path" {
    type    = string
    default = "./app.yaml"
}

variable "app_name" {
    type    = string
    default = "jupyterlab"
}


variable "jupyter_port" {
    type    = number
    default = 8888
}

# ----------- VARIABLES -------------
variable "user_name" {
    type    = string
    default = "root"
}

variable "private_key_path" {
    type    = string
}

variable "public_key_path" {
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

output "access_token" {
    value = data.template_file.access_token
}

output "endpoint" {
    value = "http://${hcloud_server.node.ipv4_address}:${var.jupyter_port}"
}