data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_host" "host" {
  datacenter_id = data.vsphere_datacenter.dc.id
  name          = var.vsphere_host
}

data "vsphere_datastore" "datastore" {
  datacenter_id = data.vsphere_datacenter.dc.id
  name          = var.vsphere_datastore
}

data "vsphere_resource_pool" "host_root" {
  datacenter_id = data.vsphere_datacenter.dc.id
  name          = "${var.vsphere_host}/Resources"
}

data "vsphere_virtual_machine" "template" {
  datacenter_id = data.vsphere_datacenter.dc.id
  name          = "/${var.vsphere_datacenter}/vm/${var.vsphere_template_folder}/${var.vsphere_template}"
}

data "vsphere_network" "dport_group" {
  datacenter_id = data.vsphere_datacenter.dc.id
  name          = var.vsphere_dport_group
}

resource "vsphere_virtual_machine" "vsphere_nodes" {
  count = var.vsphere_node_count
  name  = "PROXY${count.index}"

  resource_pool_id = data.vsphere_resource_pool.host_root.id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = var.vsphere_node_cpu_count
  memory   = var.vsphere_node_memory_size
  guest_id = data.vsphere_virtual_machine.template.guest_id

  network_interface {
    network_id = data.vsphere_network.dport_group.id
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks[0].size
    thin_provisioned = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      linux_options {
        host_name = "PROXY${count.index}"
        domain    = "dmz.inahga.org"
      }
      network_interface {}
    }
  }
}
