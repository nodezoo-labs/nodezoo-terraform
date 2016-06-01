/*
resource "aws_instance" "web" {

  instance_type = "t2.micro"

  # Lookup the correct AMI based on the region
  # we specified
  ami = "${lookup(var.amis, var.region)}"

  key_name = "${aws_key_pair.deployer.key_name}"

  # Our Security group to allow HTTP and SSH access
  security_groups = ["${aws_security_group.default.name}"]

  user_data = "${file("./scripts/userdata.sh")}"
  #Instance tags
  tags {
    Name = "elb-example"
  }
}


resource "aws_instance" "github" {

  depends_on = [
    "aws_instance.elastic",
    "aws_instance.redis"
  ]

  instance_type = "t2.micro"

  # Lookup the correct AMI based on the region
  # we specified
  ami = "${lookup(var.amis, var.region)}"

  key_name = "${aws_key_pair.deployer.key_name}"

  # Our Security group to allow HTTP and SSH access
  security_groups = ["${aws_security_group.default.name}"]

  provisioner "file" {
    source = "services/nodezoo-github/"
    destination = "/app/"
  }

  provisioner "remote-exec" {
    inline = [
      "curl -sSL https://get.docker.com/ | sudo sh",
      "sudo usermod -aG docker ubuntu",
      "docker build -t nodezoo-github /app/.",
      "docker run  --restart=on-failure:20 nodezoo-github",
    ]
  }

  #Instance tags
  tags {
    Name = "nodezoo-github"
 }
}
*/
resource "aws_instance" "npm" {
  depends_on = [
    //    "aws_key_pair.deployer",
    //    "aws_instance.elastic",
    //    "aws_instance.redis"
  ]

  instance_type = "t2.micro"

  # Lookup the correct AMI based on the region
  # we specified
  ami = "${lookup(var.amis, var.region)}"

  key_name = "${aws_key_pair.deployer.key_name}"

  # Our Security group to allow HTTP and SSH access
  security_groups = [
    "${aws_security_group.default.name}"]

  provisioner "file" {
    source = "services/nodezoo-npm/"
    destination = "/tmp"
    connection {
      user = "ubuntu"
      private_key = "${file("ssh/nodezoo")}"
    }
  }

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
      "docker build -t nodezoo-npm /tmp/.",
      "docker run  --restart=on-failure:20 -e NPM_REDIS_HOST='${aws_instance.redis.public_ip}' -e BASE_HOST='${aws_instance.base.public_ip}' nodezoo-npm"
    ]
    connection {
      user = "ubuntu"
      private_key = "${file("ssh/nodezoo")}"
    }
  }

  #Instance tags
  tags {
    Name = "nodezoo-npm"
  }
}
