provider "vsphere" {
    user = var.vcenter_user
    password = var.vcenter_password
    vsphere_server = var.vsphere_server
    allow_unverified_ssl = true
}