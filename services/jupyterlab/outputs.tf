// string variable that holds the jupyterlab token
data "template_file" "access_token" {
    template = random_password.jupyterlab_token.result
}

output "access_token" {
    value = data.template_file.access_token
}

data "template_file" "endpoint" {
    template = "https://${hcloud_server.node.ipv4_address}:443"
}

output "endpoint" {
    value = "https://${hcloud_server.node.ipv4_address}:443"
}