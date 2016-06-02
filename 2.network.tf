/*
resource "aws_elb" "web" {
  name = "example-elb"

  # The same availability zone as our instance
  availability_zones = ["${aws_instance.web.availability_zone}"]
  security_groups = ["${aws_security_group.elb.id}"]
  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/"
    interval = 30
  }  

  # The instance is registered automatically
  instances = [
    "${aws_instance.web.id}"
  ]

  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400

}

*/