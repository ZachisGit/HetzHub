output "access_token" {
    value = var.jupyterlab_token
}

output "endpoint" {
    value = module.hcloud_server.node.ipv4_address
}


resource "null_resource" "server" {

    provisioner "remote-exec" {
        inline = [
            "echo ${data.template_file.app_file.template} > ${var.app_dir}/jupyterlab/app.yaml",
            "cd ${var.app_dir}/jupyterlab",
            "docker-compose -f  up -d",
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


# Read compose file and store in variable
# to be written to compose file on server
data "template_file" "app_file" {
    template = replace(replace(file("${var.compose_file_path}"),"ACCESS_TOKEN", "${var.jupyterlab_token}"),"JUPYTER_PORT", "${var.jupyter_port}")
}

// create random jupyterlab token and hold in variable
resource "random_password" "jupyterlab_token" {
  length           = 16
  special          = false
  override_special = "_%@"
}

// string variable that holds the jupyterlab token
variable "jupyterlab_token" {
  default = random_password.jupyterlab_token.result
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

variable "app_dir" {
    type    = string
    default = "/hetzhub/apps"  
}

variable "user_name" {
    type    = string
    default = "root"
}

variable "private_key_path" {
    type    = string
}

variable "jupyter_port" {
    type    = number
    default = 8888
}

variable "instance_type" {
    type    = string
    default = "cx11"
}