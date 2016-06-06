/*Infrastructure instances*/
output "redis-public-ip" {
  value = "${aws_instance.redis.public_ip}"
}

output "base-public-ip" {
  value = "${aws_instance.base.public_ip}"
}

output "es-public-ip" {
  value = "${aws_instance.elastic.public_ip}"
}

/*App instances*/
output "npm-public-ip" {
  value = "${aws_instance.npm.public_ip}"
}

output "github-public-ip" {
  value = "${aws_instance.github.public_ip}"
}

output "travis-public-ip" {
  value = "${aws_instance.travis.public_ip}"
}

output "info-public-ip" {
  value = "${aws_instance.info.public_ip}"
}

output "search-public-ip" {
  value = "${aws_instance.search.public_ip}"
}

output "updater-public-ip" {
  value = "${aws_instance.updater.public_ip}"
}

output "dequeue-public-ip" {
  value = "${aws_instance.dequeue.public_ip}"
}

output "web-public-ip" {
  value = "${aws_instance.web.public_ip}"
}
