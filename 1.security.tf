# Specify the provider and access details
provider "aws" {
  access_key  = "${var.access_key}"
  secret_key  = "${var.secret_key}"
  region      = "${var.region}"
}

/* Define our vpc */
resource "aws_vpc" "nodezoo" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  tags {
    Name = "nodezoo-system"
  }
}

# Our default security group to access
# the instances over SSH
resource "aws_security_group" "private" {
  name = "instance_sg_nat_nodezoo"
  description = "Private security group for Nodezoo"
  vpc_id = "${aws_vpc.nodezoo.id}"

  # SSH access from anywhere
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Access all trafic for internal IPs
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["192.168.1.0/24"]
  }

  # outbound internet access
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "Private security group for Nodezoo"
  }
}

# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "web" {
  name = "instance_sg_web_nodezoo"
  description = "WEB security group for Nodezoo"
  vpc_id = "${aws_vpc.nodezoo.id}"

  # SSH access from anywhere
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH access from anywhere
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Access all trafic for internal IPs
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["192.168.1.0/24"]
  }

  # outbound internet access
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "WEB security group for Nodezoo"
  }
}
