resource "hcloud_server" "node" {
    name        = "node-${var.app_name}"
    image       = var.image
    server_type = var.instance_type
    location    = var.region
    ssh_keys    = [var.hcloud_key_id]
    backups     = var.enable_backups
}

resource "hcloud_volume" "volume" {
  name      = "volume"
  size      = var.volume_size
  server_id = hcloud_server.node.id
  automount = false
  format    = "xfs"
  delete_protection = var.delete_protection
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

            # Setup s3
            "mkdir -p ${var.app_dir}/s3",
            "export MINIO_SERVER_URL=$(cat /hetzhub/hostname); export VOLUME_PATH='/mnt/HC_Volume_${hcloud_volume.volume.id}'; export MINIO_CONFIG_FILE_PATH='${var.app_dir}/s3/config.env'; echo \"${file(var.compose_file_path)}\" > ${var.app_dir}/s3/app.yaml",
            "echo 'MINIO_ROOT_USER=\"${var.access_key}\"\nMINIO_ROOT_PASSWORD=\"${data.template_file.output_secret_key.rendered}\"' > ${var.app_dir}/s3/config.env",

            # Mount Hetzner cloud volume
            "mkfs.xfs -f  /dev/disk/by-id/scsi-0HC_Volume_${hcloud_volume.volume.id}",
            "mkdir /mnt/HC_Volume_${hcloud_volume.volume.id}",
            "mount -o discard,defaults /dev/disk/by-id/scsi-0HC_Volume_${hcloud_volume.volume.id} /mnt/HC_Volume_${hcloud_volume.volume.id}",
            "echo '/dev/disk/by-id/scsi-0HC_Volume_${hcloud_volume.volume.id} /mnt/HC_Volume_${hcloud_volume.volume.id} xfs discard,nofail,defaults 0 0' >> /etc/fstab",

            # Create IP ssl certificate
            "mkdir -p /var/lib/letsencrypt",
            "mkdir -p /etc/letsencrypt",
            "sleep 30s",
            "docker run -p 80:80 --rm --name certbot -v '/etc/letsencrypt:/etc/letsencrypt' -v '/var/lib/letsencrypt:/var/lib/letsencrypt' certbot/certbot certonly --standalone --preferred-challenges http -d $(cat /hetzhub/hostname) --non-interactive --agree-tos -m $(cat /hetzhub/hostname).$(cat /dev/urandom | tr -dc 'a-z' | fold -w 6 | head -n 1)@hetzhub.com",

            # Run compose-up
            "/hetzhub/docker-compose -f ${var.app_dir}/s3/app.yaml up -d",
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

// create random s3 secret key and hold in variable
resource "random_password" "secret_key" {
    length           = 32
    special          = false
    override_special = "_%@"
}

// create random rpc secret and hold in variable
resource "random_password" "rpc_secret" {
    length           = 32
    special          = false
    override_special = "_%@"
}