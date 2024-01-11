// ----------- VARIABLES -------------
variable "compose_file_path" {
    type    = string
    default = "../services/s3/app.yaml"
}

variable "nginx_conf_file_path" {
    type    = string
    default = "../services/s3/nginx.conf"
}

variable "minio_conf_file_path" {
    type    = string
    default = "../services/s3/config.env"
}

variable "s3_port" {
    type    = number
    default = 9000
}

variable "webui_port" {
    type    = number
    default = 443
}

variable "access_key" {
    type    = string
    default = "admin"
}

variable "app_dir" {
    type    = string
    default = "/hetzhub/apps"  
}

variable "provider_token" {
    type = string
}

variable "hcloud_key_id" {
    type = string
}

variable "zone_id" {
    type = string
}

variable "hetzner_dns_auth_token" {
    type = string
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

variable "image" {
    type    = string
    default = "ubuntu-22.04"
}

# ----------- OUTPUTS -------------

variable "region" {
    type    = string
    description = "nbg1, fsn1, hel1, ash or hil"
    default = "fsn1"
}

variable "enable_backups" {
    type    = bool
    default = false
}

variable "instance_type" {
    type    = string
}

variable "app_name" {
    type    = string
}

variable "volume_size" {
    type    = number
}

variable "delete_protection" {
    type    = bool
}