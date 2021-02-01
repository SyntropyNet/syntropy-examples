

data "digitalocean_ssh_key" "syntropy" {
  name = "syntropy" // name of keypair on digital ocean
}

resource "digitalocean_droplet" "syntropy_ipfs_gateway" {
  image              = "ubuntu-20-04-x64"
  name               = "ipfs0-gateway"
  region             = "nyc1"
  size               = "s-1vcpu-1gb"
  private_networking = true

  ssh_keys = [
    data.digitalocean_ssh_key.syntropy.id
  ]

  lifecycle {
    create_before_destroy = true // TODO: dont destrop becaue of IP
  }

  connection {
    host        = self.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = file(var.pvt_key)
    timeout     = "2m"
  }

}

resource "digitalocean_droplet" "syntropy_ipfs" {
  count              = 5
  image              = "ubuntu-20-04-x64"
  name               = "ipfs${count.index + 1}"
  region             = "nyc1"
  size               = "s-1vcpu-1gb"
  private_networking = true

  ssh_keys = [
    data.digitalocean_ssh_key.syntropy.id
  ]

  connection {
    host        = self.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = file(var.pvt_key)
    timeout     = "2m"
  }

  lifecycle {
    create_before_destroy = true // TODO: dont destrop becaue of IP
  }

  tags = [element(var.droplet_host_number, count.index)]
}

output "droplet_ip_addresses" {
  value = digitalocean_droplet.syntropy_ipfs.*.ipv4_address
}

output "droplet_gateway_address" {
  value = digitalocean_droplet.syntropy_ipfs_gateway.ipv4_address
}
output "host_numbers" {
  value = digitalocean_droplet.syntropy_ipfs[*].tags
}

output "droplet_names" {
  value = digitalocean_droplet.syntropy_ipfs.*.name
}
