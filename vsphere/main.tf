#
#

data "vsphere_datacenter" "dc" {
    name = var.vsphere_datacenter
}
