/*
resource "aws_instance" "elastic" {
  instance_type = "${var.instance_type}"

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
*/

/*
Define Redis instance
*/
resource "aws_instance" "redis" {
  instance_type = "${var.instance_type}"

  # Lookup the correct AMI based on the region
  # we specified
  ami = "${lookup(var.amis, var.region)}"

  key_name = "${aws_key_pair.deployer.key_name}"

  # Our Security group to allow HTTP and SSH access
  security_groups = ["${aws_security_group.nat.name}"]

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
      "docker run --name redis -p 6379 -d redis redis-server --appendonly yes",
      # next line is just just for debugging purposes
      "echo docker run --name redis -p 6379 -d redis redis-server --appendonly yes > docker_cmd.sh",
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

/*
Define Mesh Base instance
*/
resource "aws_instance" "base" {
  instance_type = "${var.base_instance_type}"

  # Lookup the correct AMI based on the region
  # we specified
  ami = "${lookup(var.amis, var.region)}"

  key_name = "${aws_key_pair.deployer.key_name}"

  # Our Security group to allow HTTP and SSH access
  security_groups = [
    "${aws_security_group.nat.name}"]

  # prepare app folder and install required packages
  provisioner "remote-exec" {
    inline = [
      "mkdir /tmp/app",
      "sudo apt-get update -y",
      "curl -sSL https://get.docker.com/ | sudo sh",
      "sudo usermod -aG docker ubuntu"
    ]
    connection {
      user = "ubuntu"
      private_key = "${file("ssh/nodezoo")}"
    }
  }

  # copy project files
  provisioner "file" {
    source = "services/nodezoo-base/"
    destination = "/tmp/app"
    connection {
      user = "ubuntu"
      private_key = "${file("ssh/nodezoo")}"
    }
  }

  # build and run docker
  provisioner "remote-exec" {
    inline = [
      "docker build -t nodezoo-base /tmp/app/.",
      "docker run -d --net=host -e BASE_HOST='${aws_instance.base.private_dns}' --restart=on-failure:20 nodezoo-base",
      # next line is just just for debugging purposes
      "echo docker run -d --net=host -e BASE_HOST='${aws_instance.base.private_dns}' --restart=on-failure:20 nodezoo-base > docker_cmd.sh"
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
