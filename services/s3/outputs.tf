// string variable that holds the jupyterlab token
data "template_file" "secret_key" {
    template = random_password.secret_key.result
}

output "secret_key" {
    value = data.template_file.secret_key
}

data "template_file" "rpc_secret" {
    template = random_password.rpc_secret.result
}

output "rpc_secret" {
    value = data.template_file.secret_key
}

data "template_file" "endpoint" {
    template = "https://${hcloud_server.node.ipv4_address}:443"
}

output "endpoint" {
    value = "https://${hcloud_server.node.ipv4_address}:443"
}