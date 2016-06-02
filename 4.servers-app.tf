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

/*
Define NPM app instance
*/

resource "aws_instance" "npm" {
  instance_type = "t2.micro"

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
    source = "services/nodezoo-npm/"
    destination = "/tmp/app"
    connection {
      user = "ubuntu"
      private_key = "${file("ssh/nodezoo")}"
    }
  }

  # build and run docker
  provisioner "remote-exec" {
    inline = [
      "docker build -t nodezoo-npm /tmp/app/.",
      "docker run -d --restart=on-failure:20 -e NPM_REDIS_HOST='${aws_instance.redis.private_dns}' -e NPM_HOST='${aws_instance.npm.private_dns}' -e BASE_HOST='${aws_instance.base.private_dns}:39999' nodezoo-npm",
      # next line is just just for debugging purposes
      "echo docker run -d --restart=on-failure:20 -e NPM_REDIS_HOST='${aws_instance.redis.private_dns}' -e NPM_HOST='${aws_instance.npm.private_dns}:39999' -e BASE_HOST='${aws_instance.base.private_dns}:39999' nodezoo-npm > docker_cmd.sh"
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
