// ----------- VARIABLES -------------

variable "instance_count" {
    type    = number
    default = 1
}

variable "compose_file_path" {
    type    = string
    default = "../services/jupyterlab/app.yaml"
}

variable "nginx_conf_file_path" {
    type    = string
    default = "../services/jupyterlab/nginx.conf"
}

variable "app_name" {
    type    = string
    default = "jupyterlab"
}


variable "jupyter_port" {
    type    = number
    default = 8888
}

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

variable "enable_backups" {
    type    = bool
    default = false
}