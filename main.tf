
resource "aws_vpc" "myvpc-terraform" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "${var.vpc_name}"
  }
}

resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc-terraform.id

  tags = {
    Name = "${var.igw_name}"
  }
}

resource "aws_route_table" "publicRT" {
  vpc_id = aws_vpc.myvpc-terraform.id

  tags = {
    Name = "${var.public_rt_name}"
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.publicRT.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.myigw.id
}

resource "aws_subnet" "public" {

  cidr_block = var.public_subnet_cidr
  vpc_id     = aws_vpc.myvpc-terraform.id

  tags = {
    Name = "${var.pub_sub_name}"
  }
}

resource "aws_subnet" "private" {

  cidr_block = var.private_subnet_cidr
  vpc_id     = aws_vpc.myvpc-terraform.id

  tags = {
    Name = "${var.pvt_sub_name}"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.publicRT.id
}