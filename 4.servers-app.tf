resource "aws_instance" "npm" {
  instance_type = "${var.instance_type}"

  # Lookup the correct AMI based on the region
  # we specified
  ami = "${lookup(var.amis, var.region)}"

  # subnet for this instance - only private subnet
  subnet_id = "${aws_subnet.nodezoo.id}"

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
    source = "services/nodezoo-npm/"
    destination = "/tmp/app"
  }

  # build and run docker
  provisioner "remote-exec" {
    inline = [
      "docker build -t nodezoo-npm /tmp/app/.",
      "docker run -d --restart=on-failure:20 -e NPM_REDIS_HOST='${aws_instance.redis.private_ip}' -e NPM_HOST='${aws_instance.npm.private_ip}' -e BASE_HOST='${aws_instance.base.private_ip}:39999' nodezoo-npm",
    ]
  }

  #Instance tags
  tags {
    Name = "nodezoo-npm"
  }
}

resource "aws_instance" "github" {
  instance_type = "${var.instance_type}"

  # Lookup the correct AMI based on the region
  # we specified
  ami = "${lookup(var.amis, var.region)}"

  # subnet for this instance - only private subnet
  subnet_id = "${aws_subnet.nodezoo.id}"

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
    source = "services/nodezoo-github/"
    destination = "/tmp/app"
  }

  # build and run docker
  provisioner "remote-exec" {
    inline = [
      "docker build -t nodezoo-github /tmp/app/.",
      "docker run -d --restart=on-failure:20 -e GITHUB_TOKEN='${github_token}' -e GITHUB_REDIS_HOST='${aws_instance.redis.private_ip}' -e GITHUB_HOST='${aws_instance.github.private_ip}' -e BASE_HOST='${aws_instance.base.private_ip}:39999' nodezoo-github",
    ]
  }

  #Instance tags
  tags {
    Name = "nodezoo-github"
  }
}

resource "aws_instance" "travis" {
  instance_type = "${var.instance_type}"

  # Lookup the correct AMI based on the region
  # we specified
  ami = "${lookup(var.amis, var.region)}"

  # subnet for this instance - only private subnet
  subnet_id = "${aws_subnet.nodezoo.id}"

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
    source = "services/nodezoo-travis/"
    destination = "/tmp/app"
  }

  # build and run docker
  provisioner "remote-exec" {
    inline = [
      "docker build -t nodezoo-travis /tmp/app/.",
      "docker run -d --restart=on-failure:20 -e TRAVIS_REDIS_HOST='${aws_instance.redis.private_ip}' -e TRAVIS_HOST='${aws_instance.travis.private_ip}' -e BASE_HOST='${aws_instance.base.private_ip}:39999' nodezoo-travis",
    ]
  }

  #Instance tags
  tags {
    Name = "nodezoo-travis"
  }
}

resource "aws_instance" "updater" {
  instance_type = "${var.instance_type}"

  # Lookup the correct AMI based on the region
  # we specified
  ami = "${lookup(var.amis, var.region)}"

  # subnet for this instance - only private subnet
  subnet_id = "${aws_subnet.nodezoo.id}"

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
    source = "services/nodezoo-updater/"
    destination = "/tmp/app"
  }

  # build and run docker
  provisioner "remote-exec" {
    inline = [
      "docker build -t nodezoo-updater /tmp/app/.",
      "docker run -d --restart=on-failure:20 -e UPDATER_REDIS_HOST='${aws_instance.redis.private_ip}' -e UPDATER_HOST='${aws_instance.updater.private_ip}' -e BASE_HOST='${aws_instance.base.private_ip}:39999' nodezoo-updater",
    ]
  }

  #Instance tags
  tags {
    Name = "nodezoo-updater"
  }
}

resource "aws_instance" "dequeue" {
  instance_type = "${var.instance_type}"

  # Lookup the correct AMI based on the region
  # we specified
  ami = "${lookup(var.amis, var.region)}"

  # subnet for this instance - only private subnet
  subnet_id = "${aws_subnet.nodezoo.id}"

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
    source = "services/nodezoo-dequeue/"
    destination = "/tmp/app"
  }

  # build and run docker
  provisioner "remote-exec" {
    inline = [
      "docker build -t nodezoo-dequeue /tmp/app/.",
      "docker run -d --restart=on-failure:20 -e TRAVIS_REDIS_HOST='${aws_instance.redis.private_ip}' -e DEQUEUE_HOST='${aws_instance.dequeue.private_ip}' -e BASE_HOST='${aws_instance.base.private_ip}:39999' nodezoo-dequeue",
    ]
  }

  #Instance tags
  tags {
    Name = "nodezoo-dequeue"
  }
}

resource "aws_instance" "info" {
  instance_type = "${var.instance_type}"

  # Lookup the correct AMI based on the region
  # we specified
  ami = "${lookup(var.amis, var.region)}"

  # subnet for this instance - only private subnet
  subnet_id = "${aws_subnet.nodezoo.id}"

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
    source = "services/nodezoo-info/"
    destination = "/tmp/app"
  }

  # build and run docker
  provisioner "remote-exec" {
    inline = [
      "docker build -t nodezoo-info /tmp/app/.",
      "docker run -d --restart=on-failure:20 -e INFO_HOST='${aws_instance.info.private_ip}' -e BASE_HOST='${aws_instance.base.private_ip}:39999' nodezoo-info",
    ]
  }

  #Instance tags
  tags {
    Name = "nodezoo-info"
  }
}

resource "aws_instance" "search" {
  instance_type = "${var.instance_type}"

  # Lookup the correct AMI based on the region
  # we specified
  ami = "${lookup(var.amis, var.region)}"

  # subnet for this instance - only private subnet
  subnet_id = "${aws_subnet.nodezoo.id}"

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
    source = "services/nodezoo-search/"
    destination = "/tmp/app"
  }

  # build and run docker
  provisioner "remote-exec" {
    inline = [
      "docker build -t nodezoo-search /tmp/app/.",
      "docker run -d --restart=on-failure:20 -e SEARCH_ELASTIC_HOST='${aws_instance.elastic.private_ip}' -e SEARCH_HOST='${aws_instance.search.private_ip}' -e BASE_HOST='${aws_instance.base.private_ip}:39999' nodezoo-search",
    ]
  }

  #Instance tags
  tags {
    Name = "nodezoo-search"
  }
}

resource "aws_instance" "web" {
  instance_type = "${var.small_instance_type}"

  # Lookup the correct AMI based on the region
  # we specified
  ami = "${lookup(var.amis, var.region)}"

  # subnet for this instance - only private subnet
  subnet_id = "${aws_subnet.nodezoo.id}"

  key_name = "${aws_key_pair.deployer.key_name}"

  # Our Security group to allow HTTP and SSH access
  # HINT: Because we are using also subnet_id the id of security group should be used instead of name
  vpc_security_group_ids = ["${aws_security_group.web.id}"]

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
    source = "services/nodezoo-web/"
    destination = "/tmp/app"
  }

  # build and run docker
  provisioner "remote-exec" {
    inline = [
      "docker build -t nodezoo-web /tmp/app/.",
      "docker run -d --restart=on-failure:20 -p 80:8000 -e WEB_HOST='${aws_instance.web.private_ip}' -e BASE_HOST='${aws_instance.base.private_ip}:39999' nodezoo-web",
    ]
  }

  #Instance tags
  tags {
    Name = "nodezoo-web"
  }
}
