/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "nodezoo" {
  vpc_id = "${aws_vpc.nodezoo.id}"
}

/* Public subnet */
resource "aws_subnet" "nodezoo" {
  vpc_id            = "${aws_vpc.nodezoo.id}"
  cidr_block        = "${var.public_subnet_cidr}"
  availability_zone = "us-west-1b"
  map_public_ip_on_launch = true
  depends_on = ["aws_internet_gateway.nodezoo"]
  tags {
    Name = "public"
  }
}

/* Routing table for public subnet */
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.nodezoo.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.nodezoo.id}"
  }
}

/* Associate the routing table to public subnet */
resource "aws_route_table_association" "public" {
  subnet_id = "${aws_subnet.nodezoo.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_eip" "lb" {
  instance = "${aws_instance.web.id}"
  vpc      = true
}

