terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 1.0"
    }
  }
}

resource "digitalocean_ssh_key" "ssh_keys" {
  for_each   = var.ssh_keys
  name       = each.key
  public_key = each.value
}
