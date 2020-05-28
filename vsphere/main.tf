#
#

data "vsphere_datacenter" "dc" {
    name = var.vsphere_datacenter
}

data "vsphere_distributed_virtual_switch" "dswitch0" {
    name = "DSwitch0"
    datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_host" "hosts" {
    for_each = var.vsphere_hosts
    name = each.key
    datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "packer_templates" {
    for_each = var.vsphere_packer_templates
    name = "/${var.vsphere_datacenter}/vm/${var.vsphere_packer_template_folder}/${each.value}"
    datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_distributed_port_group" "port_groups" {
    for_each = var.vsphere_port_groups
    distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.dswitch0.id
    name = each.key
    vlan_id = each.value
}
