data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_distributed_virtual_switch" "dswitch0" {
  name          = "DSwitch0"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_host" "hosts" {
  for_each      = var.vsphere_hosts
  name          = each.key
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Grabs the root resource pool for each host.
data "vsphere_resource_pool" "root_pools" {
  for_each      = var.vsphere_hosts
  name          = "${each.key}/Resources"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastores" {
  for_each      = var.vsphere_datastores
  name          = each.key
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "packer_templates" {
  for_each      = var.vsphere_packer_templates
  name          = "/${var.vsphere_datacenter}/vm/${var.vsphere_packer_template_folder}/${each.value}"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_distributed_port_group" "port_groups" {
  for_each                        = var.vsphere_port_groups
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.dswitch0.id
  name                            = each.key
  vlan_id                         = each.value
}


# resource "vsphere_virtual_machine" "CENTOS8TST" {
#     name = "CENTOS8TST"
#     resource_pool_id = data.vsphere_resource_pool.root_pools["esxi2.vsphere.inahga.org"].id
#     datastore_id = data.vsphere_datastore.datastores["esxi2-Local"].id

#     num_cpus = 2
#     memory = 2048
#     guest_id = "centos8_64Guest"

#     network_interface {
#         network_id = vsphere_distributed_port_group.port_groups["DPG-TF-20-Intranet"].id
#     }

#     disk {
#         label = "disk0"
#         size = data.vsphere_virtual_machine.packer_templates["centos_8_latest"].disks[0].size
#         thin_provisioned = true
#     }

#     clone {
#         template_uuid = data.vsphere_virtual_machine.packer_templates["centos_8_latest"].id
#         customize {
#             linux_options {
#                 host_name = "CENTOS8TST"
#                 domain = "public.inahga.org"
#             }
#             network_interface {}
#         }
#     }
# }

