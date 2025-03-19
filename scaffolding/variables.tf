variable "digitalocean_apikey" {}

variable "aws_region" {
  default = "us-west-2"
}

variable "ssh_keys" {
  type = map(string)
  default = {
    inahga1 = "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIHLtwflRB2PAPOAtqRpH5z7TJ/AG9iKo9pDUo/NdP0KyAAAAEXNzaDp5dWJpa2V5LXNtYWxs"
    inahga2 = "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBOSSQ4OWadN+OA8FcemI8m+0th+OpOQBnlQPiElzsZvJZ2AN74N6R0av5DyifbkNXI53zMmEJBnvbrJOb/T1bosAAAARc3NoOnl1YmlrZXktc21hbGw="
    inahga3 = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDhnRHibSWdeB4TO9D/K/1O4P7euN57HI+WNs4bIau+y2pT157zi6NteNJrdVLdom1CR7Jn4cPaDydPWKYjbQIU7mlFOIVF+nFs+HeGX2f2+Jub+IAgK9rWmU6OVgQGC29PLCQEr67TeM0Xtn6C2TCx6j58tXkzMJxthr47SY8ucl8/opvoN1xgQUFP9GoXdTamxFUL0xMW4cLdgMLt0fTuLX5jrxKB8+wW9pzdl/Nz7JLS4TXAxsypb6p/hHoegeb5s/CL0SFcjZ6qp1ld6plIVA5pJb00dCLh0hEhe6OhlBC4hWeJxXXXtmpJNJqS2bfkVD6fdOABrXWB5ivaV+Lj"
  }
}
