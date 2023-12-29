resource "hcloud_ssh_key" "hetzhub_key" {
    name       = "HetzHub SSH keys"
    public_key = file("${var.public_key_path}")
}

resource "hcloud_server" "node" {
    name        = "node"
    image       = var.image
    server_type = var.instance_type
    location    = var.region
    ssh_keys    = [hcloud_ssh_key.hetzhub_key.id]
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

resource "terraform_data" "server" {
    depends_on = [hcloud_server.node]

    # Server connection SSH
    connection {
        type        = "ssh"
        user        = var.ssh_user_name
        private_key = file("${var.private_key_path}")
        host        = hcloud_server.node.ipv4_address
    }

    # Run commands on server to setup docker-compose
    # and start the s3 service
    provisioner "remote-exec" {
        inline = [
            # Standard setup of node with docker-compose
            "sudo apt-get update",
            "sudo apt-get install -y docker.io",
            "mkdir -p /hetzhub",
            "mkdir -p ${var.app_dir}",
            "wget https://github.com/docker/compose/releases/download/v2.23.3/docker-compose-linux-x86_64 -O /hetzhub/docker-compose",
            "chmod +x /hetzhub/docker-compose",
            "mkdir -p ${var.app_dir}/s3",
            "export MINIO_SERVER_URL='${hcloud_server.node.ipv4_address}'; export VOLUME_PATH='/mnt/HC_Volume_${hcloud_volume.volume.id}'; export MINIO_CONFIG_FILE_PATH='${var.app_dir}/s3/config.env'; export NGINX_CONF_PATH='${var.app_dir}/s3/nginx.conf'; export NGINX_CERT_PATH='${var.app_dir}/s3/cert.pem'; export NGINX_KEY_PATH='${var.app_dir}/s3/key.pem'; echo \"${file(var.compose_file_path)}\" > ${var.app_dir}/s3/app.yaml",
            "export NGINX_SERVER_NAME='${hcloud_server.node.ipv4_address}'; echo \"${file("${var.nginx_conf_file_path}")}\" > ${var.app_dir}/s3/nginx.conf",
            "echo 'MINIO_ROOT_USER=\"${var.access_key}\"\nMINIO_ROOT_PASSWORD=\"${data.template_file.secret_key.rendered}\"' > ${var.app_dir}/s3/config.env",

            # Mount Hetzner cloud volume
            "mkfs.xfs -f  /dev/disk/by-id/scsi-0HC_Volume_${hcloud_volume.volume.id}",
            "mkdir /mnt/HC_Volume_${hcloud_volume.volume.id}",
            "mount -o discard,defaults /dev/disk/by-id/scsi-0HC_Volume_${hcloud_volume.volume.id} /mnt/HC_Volume_${hcloud_volume.volume.id}",
            "echo '/dev/disk/by-id/scsi-0HC_Volume_${hcloud_volume.volume.id} /mnt/HC_Volume_${hcloud_volume.volume.id} xfs discard,nofail,defaults 0 0' >> /etc/fstab",

            # Create IP ssl certificate
            "wget https://raw.githubusercontent.com/antelle/generate-ip-cert/master/generate-ip-cert.sh -O ${var.app_dir}/s3/generate-ip-cert.sh",
            "chmod +x ${var.app_dir}/s3/generate-ip-cert.sh",
            "cd ${var.app_dir}/s3/",
            "${var.app_dir}/s3/generate-ip-cert.sh ${hcloud_server.node.ipv4_address}",

            # Run compose-up
            "/hetzhub/docker-compose -f ${var.app_dir}/s3/app.yaml up -d",
        ]
    }
  
    lifecycle {
        create_before_destroy = false
    }
}

/*
docker run -v $PWD/certs:/certs \
  -e SSL_SUBJECT=$DOMAIN \
  -e SSL_DNS=$DOMAIN \
  superseb/omgwtfssl
*/


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
