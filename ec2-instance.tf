locals {
  instance_names = ["nginx", "tomcat", "jenkins", "docker"]
}

resource "aws_security_group" "myPublicSG" {
  name        = var.sg_name
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.sg_name}"
  }
}

resource "aws_instance" "nginx-server" {
  ami = var.instance_ami #This is an example Amazon Linux 2 AMI ID; replace it with the appropriate AMI ID for your desired instance type and region.

  count = length(local.instance_names)

  instance_type = var.machine_type

  vpc_security_group_ids = [aws_security_group.myPublicSG.id]

  key_name = var.kp_name # Replace with the name of your existing key pair.

  associate_public_ip_address = true

  root_block_device {
    volume_size = 20
  }
  tags = {
    Name = element(local.instance_names, count.index)
  }
}