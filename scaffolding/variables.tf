variable "vsphere_user" {}
variable "vsphere_password" {}
variable "digitalocean_apikey" {}

variable "vsphere_server" {
  default = "vcsa0.vsphere.inahga.org"
}

variable "aws_region" {
  default = "us-west-2"
}

variable "ssh_keys" {
  type = map(string)
  default = {
    aghani = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC8KsdwZhjOBKbNMtsRJFwYvWZ8SISJSV9xVzVsK8B7mNU+SVtaVP5/VJVUJoJq+D6yPUU2QYnwTfwJ5HZDibjYuU5ReSjb/sKWByRzl5Rt0nxXHrNUeycgaZwqyYmNysmuyyI0PE8Hb5yxYJO9elRnoFyV5tEJEptniHOubVCjawIh+aQg8kEPMH0erbgnR3r62sK3j6whpc4bjU9kS6aQeY5oRg52xDIkK7vFZJpVPPQmk3uZztYZ4UjejBbDcDK8lMl+m3Zr7rplSu2NthSZ2iTTDL6F8Zg9YEVo23H1ABI7p0xtHwXmqWFQYTRawOeaVzVF8r6kW+oOCjKHI1M+svzmkYvUGJs43OziDz0zYWla5P0jxzcExaBLuzBYmYrzGCd/eCZLxS89RQoxnPCkPYzlUHRoOYpAxpzeWUetcVYDVwKbqspmHbVW0tsSL7eTDvMwT9BT2/SfjRXo9sKOEgRahG0NqlWcpv6oUU7d7MKKpQC3uF+7xd1Y34Nx/3k= aghani@TPT480"
  }
}

variable "local_ip_address" {
  default = "67.184.128.2"
}

