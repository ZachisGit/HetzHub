// ----------- VARIABLES -------------
variable "instance_count" {
    type    = number
    default = 1
}

variable "app_dir" {
    type    = string
    default = "/hetzhub/apps"  
}

variable "compose_file_path" {
    type    = string
    default = "../services/jupyterlab/app.yaml"
}

variable "nginx_conf_file_path" {
    type    = string
    default = "../services/jupyterlab/nginx.conf"
}

variable "provider_token" {
    type    = string
}

variable "jupyter_port" {
    type    = number
    default = 8888
}

variable "ssh_user_name" {
    type    = string
    default = "root"
}

variable "private_key" {
    type    = string
}

variable "public_key" {
    type    = string
}

variable "hcloud_key_id" {
    type = string
}

variable "image" {
    type    = string
    default = "ubuntu-22.04"
}

variable "hetzner_dns_auth_token" {
    type = string
}

variable "zone_id" {
    type = string
}

# ----------------- USER VARIABLES -----------------
variable "region" {
    type    = string
    description = "nbg1, fsn1, hel1, ash or hil"
    default = "fsn1"
}

variable "app_name" {
    type    = string
}

variable "instance_type" {
    type    = string
}

variable "enable_backups" {
    type    = bool
}

variable "delete_protection" {
    type    = bool
}