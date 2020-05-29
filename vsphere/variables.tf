#
#

variable vsphere_datacenter {
    default = "Datacenter"
}

variable vsphere_packer_template_folder {
    default = "PackerTemplates"
}

variable vsphere_packer_templates {
    type = map
    default = {
        centos_8_latest = "Packer_CentOS_8_Latest"
        centos_7_latest = "Packer_CentOS_7_Latest"
    }
}

variable vsphere_port_groups {
    type = map
    default = {
        "DPG-TF-10-Public" = 10
        "DPG-TF-20-Intranet" = 20
        "DPG-TF-30-DMZ" = 30
    }
}

variable vsphere_hosts {
    type = set(string)
    default = [
        "esxi2.vsphere.inahga.org",
        "esxi4.vsphere.inahga.org",
        "esxi5.vsphere.inahga.org"
    ]
}

variable vsphere_datastores {
    type = set(string)
    default = [
        "esxi2-Local",
        "esxi4-Local",
        "esxi5-Local"
    ]
}
