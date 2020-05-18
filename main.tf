
provider "aws" {}

resource "aws_vpc" "aesop" {
  cidr_block = "10.70.0.0/16"

  tags = {
    Name = "aesop"
  }
}

resource "aws_internet_gateway" "aesop" {
  vpc_id = aws_vpc.aesop.id
}

resource "aws_subnet" "exo" {
  vpc_id = aws_vpc.aesop.id
  cidr_block = "10.70.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "exo-aesop"
  }
}

resource "aws_security_group" "mgmt_exo" {
  name        = "mgmt_exo_aesop"
  description = "secure management endpoint, limited external access"
  vpc_id = aws_vpc.aesop.id

  # whitelist client ssh access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [ "99.10.10.5/32" ]
    description = "hstntx.sbcglobal.net - whitelist"
  }
}

resource "aws_security_group" "vpn_ep" {
  name        = "vpn_ep_aesop"
  description = "public vpn endpoint, secure network access"
  vpc_id = aws_vpc.aesop.id

  # whitelist client ssh access
  ingress {
    from_port   = 29604
    to_port     = 29604
    protocol    = "udp"
    cidr_blocks = [ "0.0.0.0/0", "::/0" ]
    description = "wireguard"
  }
}

resource "aws_instance" "razor" {
  ami           = "ami-0f7919c33c90f5b58"
  instance_type = "t2.medium"

  vpc_security_group_ids = [
    aws_security_group.mgmt_exo.id,
    aws_vpc.aesop.default_security_group_id
  ]

  subnet_id = aws_subnet.exo.id

  root_block_device {
    delete_on_termination = true
    volume_size = 32
  }

  tags = {
    Name = "razor"
  }
}

