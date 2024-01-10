resource "hcloud_server" "node" {
    name        = "node-${var.app_name}"
    image       = var.image
    server_type = var.instance_type
    location    = var.region
    ssh_keys    = [var.hcloud_key_id]
}

resource "remote_file" "subdomain_service" {
    depends_on = [hcloud_server.node]
    conn {
        host        = hcloud_server.node.ipv4_address
        port        = 22
        user        = var.ssh_user_name
        private_key = file("${var.private_key_path}")
    }

    path        = "/root/subdomain-service"
    content     = file("../subdomain-service/subdomain-service-linux")
    permissions = "0644"
}

resource "terraform_data" "server" {
    depends_on = [remote_file.bashrc]

    # Server connection SSH
    connection {
        type        = "ssh"
        user        = var.ssh_user_name
        private_key = file("${var.private_key_path}")
        host        = hcloud_server.node.ipv4_address
    }

    # Run commands on server to setup docker-compose
    # and start the jupyterlab service
    provisioner "remote-exec" {
        inline = [
            # Standard setup of node with docker-compose
            "sudo apt-get update",
            "sudo apt-get install -y docker.io jq",
            "mkdir -p /hetzhub",
            "mkdir -p ${var.app_dir}",
            
            # Get hostname of server
            "/root/servie-subdomain '${hcloud_server.node.ipv4_address}'",
            #"curl -H 'Authorization: Bearer ${var.provider_token}' 'https://api.hetzner.cloud/v1/servers/${hcloud_server.node.id}' | jq -r '.server.public_net.ipv4.dns_ptr' > /hetzhub/hostname",

            "wget https://github.com/docker/compose/releases/download/v2.23.3/docker-compose-linux-x86_64 -O /hetzhub/docker-compose",
            "chmod +x /hetzhub/docker-compose",
            "mkdir -p ${var.app_dir}/jupyterlab",
            "export NGINX_CONF_PATH='${var.app_dir}/jupyterlab/nginx.conf'; export NGINX_CERT_PATH='/etc/letsencrypt/archive/$(cat /hetzhub/hostname)/fullchain1.pem'; export NGINX_KEY_PATH='/etc/letsencrypt/archive/$(cat /hetzhub/hostname)/privkey1.pem'; export ACCESS_TOKEN=\"${data.template_file.access_token.rendered}\"; export JUPYTER_PORT=${var.jupyter_port}; echo \"${file(var.compose_file_path)}\" > ${var.app_dir}/jupyterlab/app.yaml",
            "export NGINX_SERVER_NAME=$(cat /hetzhub/hostname); echo \"${file("${var.nginx_conf_file_path}")}\" > ${var.app_dir}/jupyterlab/nginx.conf",

            # Set permissions and run compose-up
            "mkdir -p ${var.app_dir}/jupyterlab/data",
            "chown -R 1000:100 /hetzhub/apps/jupyterlab/data",
            "chmod -R 775 /hetzhub/apps/jupyterlab/data",

            # Create IP ssl certificate
            "mkdir -p /var/lib/letsencrypt",
            "mkdir -p /etc/letsencrypt",
            "docker run -p 80:80 --rm --name certbot -v '/etc/letsencrypt:/etc/letsencrypt' -v '/var/lib/letsencrypt:/var/lib/letsencrypt' certbot/certbot certonly --standalone --preferred-challenges http -d $(cat /hetzhub/hostname) --non-interactive --agree-tos -m $(cat /hetzhub/hostname).$(cat /dev/urandom | tr -dc 'a-z' | fold -w 6 | head -n 1)@hetzhub.com",

            "/hetzhub/docker-compose -f ${var.app_dir}/jupyterlab/app.yaml up -d",
        ]

    }
  
    lifecycle {
        create_before_destroy = false
    }
}

// create random jupyterlab token and hold in variable
resource "random_password" "jupyterlab_token" {
    length           = 16
    special          = false
    override_special = "_%@"
}
