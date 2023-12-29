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

variable "app_name" {
    type    = string
    default = "s3"
}

variable "access_key" {
    type    = string
    default = "admin"
}

variable "s3_port" {
    type    = number
    default = 9000
}

variable "webui_port" {
    type    = number
    default = 443
}

variable "ssh_user_name" {
    type    = string
    default = "root"
}

variable "volume_size" {
    type    = number
    default = 10
}

variable "delete_protection" {
    type    = bool
    default = false
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
    default = "CPX11"
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