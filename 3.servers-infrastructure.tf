resource "aws_instance" "elastic" {
  instance_type = "${var.instance_type}"

  # Lookup the correct AMI based on the region
  # we specified
  ami = "${lookup(var.amis, var.region)}"

  key_name = "${aws_key_pair.deployer.key_name}"

  # subnet for this instance - only private subnet
  subnet_id = "${aws_subnet.nodezoo.id}"

  # Our Security group
  security_groups = ["${aws_security_group.private.id}"]

  connection {
    user = "ubuntu"
    private_key = "${file("ssh/nodezoo")}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "curl -sSL https://get.docker.com/ | sudo sh",
      "sudo usermod -aG docker ubuntu"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "docker run -d -p 9200:9200 -p 9300:9300 elasticsearch"
    ]
  }

  #Instance tags
  tags {
    Name = "nodezoo-elastic"
 }
}

resource "aws_instance" "redis" {
  instance_type = "${var.small_instance_type}"

  # Lookup the correct AMI based on the region
  # we specified
  ami = "${lookup(var.amis, var.region)}"

  # subnet for this instance - only private subnet
  subnet_id = "${aws_subnet.nodezoo.id}"

  key_name = "${aws_key_pair.deployer.key_name}"

  private_ip = "${var.redis_private_ip}"

  # Our Security group
  security_groups = ["${aws_security_group.private.id}"]

  connection {
    user = "ubuntu"
    private_key = "${file("ssh/nodezoo")}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "curl -sSL https://get.docker.com/ | sudo sh",
      "sudo usermod -aG docker ubuntu"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      # next line is just just for debugging purposes
      "echo docker run --name redis -p 6379:6379 -d redis redis-server --appendonly yes > docker_cmd.sh",
      "docker run --name redis -p 6379:6379 -d redis redis-server --appendonly yes",
    ]
  }

  #Instance tags
  tags {
    Name = "nodezoo-redis"
 }
}

resource "aws_instance" "base" {
  instance_type = "${var.instance_type}"

  # Lookup the correct AMI based on the region
  # we specified
  ami = "${lookup(var.amis, var.region)}"

  # subnet for this instance - only private subnet
  subnet_id = "${aws_subnet.nodezoo.id}"

  private_ip = "${var.base_private_ip}"

  key_name = "${aws_key_pair.deployer.key_name}"

  # Our Security group to allow HTTP and SSH access
  # HINT: Because we are using also subnet_id the id of security group should be used instead of name
  security_groups = ["${aws_security_group.private.id}"]

  connection {
    user = "ubuntu"
    private_key = "${file("ssh/nodezoo")}"
  }

  # prepare app folder and install required packages
  provisioner "remote-exec" {
    inline = [
      "mkdir /tmp/app",
      "sudo apt-get update -y",
      "curl -sSL https://get.docker.com/ | sudo sh",
      "sudo usermod -aG docker ubuntu"
    ]
  }

  # copy project files
  provisioner "file" {
    source = "services/nodezoo-base/"
    destination = "/tmp/app"
  }

  # build and run docker
  provisioner "remote-exec" {
    inline = [
      "docker build -t nodezoo-base /tmp/app/.",
      # next line is just just for debugging purposes
      "echo docker run -d --net=host -e BASE_HOST='${var.base_private_ip}' --restart=on-failure:20 nodezoo-base > docker_cmd.sh",
      "docker run -d --net=host -e BASE_HOST='${var.base_private_ip}' --restart=on-failure:20 nodezoo-base"
    ]
  }

  #Instance tags
  tags {
    Name = "nodezoo-base"
  }
}
