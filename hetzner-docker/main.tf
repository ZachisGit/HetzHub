# Create a new SSH key
resource "hcloud_ssh_key" "provisioner" {
  name       = "Provisioner SSH keys"
  public_key = file("~/.ssh/pillow.pub")
}

resource "hcloud_server" "node" {
  name        = "node0"
  image       = "ubuntu-22.04"
  server_type = "cpx21" # assuming this is the smallest instance type
  location    = "fsn1" # Frankfurt is a common location in Germany
  ssh_keys    = [hcloud_ssh_key.provisioner.id]
}

resource "null_resource" "docker_install" {
  depends_on = [hcloud_server.node]

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y docker.io",
    ]

    connection {
      type        = "ssh"
      user        = "root"
      private_key = file("~/.ssh/pillow")
      host        = hcloud_server.node.ipv4_address
    }
  }
}