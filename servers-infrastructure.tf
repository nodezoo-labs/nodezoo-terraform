resource "aws_instance" "elastic" {
  instance_type = "t2.micro"

  # Lookup the correct AMI based on the region
  # we specified
  ami = "${lookup(var.amis, var.region)}"

  key_name = "${aws_key_pair.deployer.key_name}"

  # Our Security group to allow HTTP and SSH access
  security_groups = ["${aws_security_group.default.name}"]

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
//      "sudo apt-get install lxc wget bsdtar curl",
//      "sudo apt-get install linux-image-extra-$(uname -r)",
//      "sudo modprobe aufs",
      "curl -sSL https://get.docker.com/ | sudo sh",
      "sudo usermod -aG docker ubuntu"
    ]
    connection {
      user = "ubuntu"
      private_key = "${file("ssh/nodezoo")}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "docker run -d -p 9200:9200 -p 9300:9300 elasticsearch"
    ]
    connection {
      user = "ubuntu"
      private_key = "${file("ssh/nodezoo")}"
    }
  }

  #Instance tags
  tags {
    Name = "nodezoo-elastic"
 }
}

resource "aws_instance" "redis" {
  instance_type = "t2.micro"

  # Lookup the correct AMI based on the region
  # we specified
  ami = "${lookup(var.amis, var.region)}"

  key_name = "${aws_key_pair.deployer.key_name}"

  # Our Security group to allow HTTP and SSH access
  security_groups = ["${aws_security_group.default.name}"]

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
//      "sudo apt-get install lxc wget bsdtar curl",
//      "sudo apt-get install linux-image-extra-$(uname -r)",
//      "sudo modprobe aufs",
      "curl -sSL https://get.docker.com/ | sudo sh",
      "sudo usermod -aG docker ubuntu"
    ]
    connection {
      user = "ubuntu"
      private_key = "${file("ssh/nodezoo")}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "docker run --name redis -p 6379 -d redis redis-server --appendonly yes"
    ]
    connection {
      user = "ubuntu"
      private_key = "${file("ssh/nodezoo")}"
    }
  }

  #Instance tags
  tags {
    Name = "nodezoo-redis"
 }
}

resource "aws_instance" "base" {
  instance_type = "t2.micro"

  # Lookup the correct AMI based on the region
  # we specified
  ami = "${lookup(var.amis, var.region)}"

  key_name = "${aws_key_pair.deployer.key_name}"

  # Our Security group to allow HTTP and SSH access
  security_groups = [
    "${aws_security_group.default.name}"]

  provisioner "file" {
    source = "services/nodezoo-base/"
    destination = "/tmp"
    connection {
      user = "ubuntu"
      private_key = "${file("ssh/nodezoo")}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "curl -sSL https://get.docker.com/ | sudo sh",
      "sudo usermod -aG docker ubuntu"
    ]
    connection {
      user = "ubuntu"
      private_key = "${file("ssh/nodezoo")}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "docker build -t nodezoo-base /tmp/.",
      "docker run  --restart=on-failure:20 nodezoo-base"
    ]
    connection {
      user = "ubuntu"
      private_key = "${file("ssh/nodezoo")}"
    }
  }

  #Instance tags
  tags {
    Name = "nodezoo-base"
  }
}
