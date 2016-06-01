/*output "elb-address" {
  value = "${aws_elb.web.dns_name}"
}

output "elastic-address" {
  value = "${aws_instance.elastic.public_ip}"
}

output "redis-address" {
  value = "${aws_instance.redis.public_ip}"
}

output "web-address" {
  value = "${aws_instance.web.public_ip}"
}

output "github-address" {
  value = "${aws_instance.github.public_ip}"
}
*/

output "npm-ip" {
  value = "${aws_instance.npm.public_ip}"
}

output "npm-private-ip" {
  value = "${aws_instance.npm.private_ip}"
}

output "base-ip" {
  value = "${aws_instance.base.public_ip}"
}

output "base-private-ip" {
  value = "${aws_instance.base.private_ip}"
}
