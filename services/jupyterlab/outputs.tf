data "template_file" "output_access_token" {
    template = random_password.jupyterlab_token.result
}

output "access_token" {
    value = data.template_file.output_access_token
}

data "template_file" "output_endpoint" {
    template = "https://${data.remote_file.hostname.content}"
}

output "endpoint" {
    value = "https://${data.remote_file.hostname.content}"
}

data "template_file" "output_service_id" {
    template = "jupyterlab"
}

output "service_id" {
    value = "jupyterlab"
}

data "template_file" "output_ssh_private_key" {
    template = var.private_key
}

output "ssh_private_key" {
    value = var.private_key
}

data "template_file" "output_ssh_public_key" {
    template = var.public_key
}

output "ssh_public_key" {
    value = var.public_key
}

data "template_file" "output_node_ip" {
    template = hcloud_server.node.ipv4_address
}

output "node_ip" {
    value = hcloud_server.node.ipv4_address
}

# ------------- INPUTS -------------
data "template_file" "input_region" {
    template = var.region
}

output "region" {
    value = var.region
}

data "template_file" "input_app_name" {
    template = var.app_name
}

output "app_name" {
    value = var.app_name
}

data "template_file" "input_instance_type" {
    template = var.instance_type
}

output "instance_type" {
    value = var.instance_type
}

data "template_file" "input_enable_backups" {
    template = var.enable_backups
}

output "enable_backups" {
    value = var.enable_backups
}

data "template_file" "output_delete_protection" {
    template = var.delete_protection
}

output "delete_protection" {
    value = var.delete_protection
}
