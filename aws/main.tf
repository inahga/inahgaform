module "iam" {
    source = "./iam"
    ssh_keys = var.ssh_keys
}

module "lb" {
    source = "./lb"
    inventory_dir = var.inventory_dir
    aws_ssh_key_name = "aghani"
    aws_instance_type = "t2.micro"
    aws_ami_id = data.aws_ami.rhel8.id
    node_count = 1
}

data "aws_ami" "centos8_2" {
    owners = ["125523088429"]
    filter {
        name = "image-id"
        values = ["ami-0157b1e4eefd91fd7"]
    }
}

data "aws_ami" "fedora32" {
    owners = ["125523088429"]
    filter {
        name = "image-id"
        values = ["ami-020405ee5d5747724"]
    }
}

data "aws_ami" "rhel8" {
    owners = ["309956199498"]
    filter {
        name = "image-id"
        values = ["ami-02f147dfb8be58a10"]
    }
}
