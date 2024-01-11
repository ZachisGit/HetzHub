resource "hcloud_server" "node" {
    name        = "node-${var.app_name}"
    image       = var.image
    server_type = var.instance_type
    location    = var.region
    ssh_keys    = [var.hcloud_key_id]
}

resource "time_sleep" "wait_30_seconds" {
  depends_on = [hcloud_server.node]

  create_duration = "30s"
}

resource "terraform_data" "server" {
    depends_on = [time_sleep.wait_30_seconds]

    # Server connection SSH
    connection {
        type        = "ssh"
        user        = var.ssh_user_name
        private_key = var.private_key
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
            "wget https://github.com/ZachisGit/HetzHub/releases/download/latest/subdomain-service-linux -O /root/subdomain-service",
            "chmod +x /root/subdomain-service",
            "/root/subdomain-service '${hcloud_server.node.ipv4_address}' 'hetzhub.com' '${var.zone_id}' '${var.hetzner_dns_auth_token}' '/hetzhub/hostname'",

            # Setup docker-compose
            "wget https://github.com/docker/compose/releases/download/v2.23.3/docker-compose-linux-x86_64 -O /hetzhub/docker-compose",
            "chmod +x /hetzhub/docker-compose",

            # Setup jupyterlab
            "mkdir -p ${var.app_dir}/jupyterlab",
            format("export NGINX_CONF_PATH='${var.app_dir}/jupyterlab/nginx.conf'; export NGINX_CERT_PATH=/etc/letsencrypt/archive/$(cat /hetzhub/hostname)/cert1.pem; export NGINX_KEY_PATH=/etc/letsencrypt/archive/$(cat /hetzhub/hostname)/privkey1.pem; export ACCESS_TOKEN=\"${data.template_file.output_access_token.rendered}\"; export JUPYTER_PORT=${var.jupyter_port}; echo \"${file(var.compose_file_path)}\" > ${var.app_dir}/jupyterlab/app.yaml"),
            "export NGINX_SERVER_NAME=$(cat /hetzhub/hostname); echo \"${file("${var.nginx_conf_file_path}")}\" > ${var.app_dir}/jupyterlab/nginx.conf",

            # Set permissions and run compose-up
            "mkdir -p ${var.app_dir}/jupyterlab/data",
            "chown -R 1000:100 /hetzhub/apps/jupyterlab/data",
            "chmod -R 775 /hetzhub/apps/jupyterlab/data",

            # Create IP ssl certificate
            "mkdir -p /var/lib/letsencrypt",
            "mkdir -p /etc/letsencrypt",
            "sleep 30s",
            "docker run -p 80:80 --rm --name certbot -v '/etc/letsencrypt:/etc/letsencrypt' -v '/var/lib/letsencrypt:/var/lib/letsencrypt' certbot/certbot certonly --standalone --preferred-challenges http -d $(cat /hetzhub/hostname) --non-interactive --agree-tos -m $(cat /hetzhub/hostname).$(cat /dev/urandom | tr -dc 'a-z' | fold -w 6 | head -n 1)@hetzhub.com",

            "/hetzhub/docker-compose -f ${var.app_dir}/jupyterlab/app.yaml up -d",
        ]

    }
  
    lifecycle {
        create_before_destroy = false
    }
}

data "remote_file" "hostname" {
    depends_on = [terraform_data.server]
    conn {
        host     = hcloud_server.node.ipv4_address
        user     = var.ssh_user_name
        private_key = var.private_key
        sudo     = true
    }

    path = "/hetzhub/hostname"
}


// create random jupyterlab token and hold in variable
resource "random_password" "jupyterlab_token" {
    length           = 16
    special          = false
    override_special = "_%@"
}
