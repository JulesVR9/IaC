# main.tf

# Obtener la AMI de Ubuntu más reciente
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["099720109477"]
}

# Key Pair
resource "aws_key_pair" "ssh_key" {
  key_name   = "ec2"
  public_key = file(var.public_key)
}

# Security Group
resource "aws_security_group" "sg" {
  name        = "actividad10_sg"
  description = "Allow SSH and HTTP"

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Definir instancias
locals {
  instances = {
    dev  = { ami = data.aws_ami.ubuntu.id, instance_type = "t3.micro" }
    qa   = { ami = data.aws_ami.ubuntu.id, instance_type = "t3.micro" }
    prod = { ami = data.aws_ami.ubuntu.id, instance_type = "t3.micro" }
  }
}

resource "aws_instance" "actividad10_nodes" {
  for_each                    = local.instances
  ami                         = each.value.ami
  instance_type               = each.value.instance_type
  key_name                    = aws_key_pair.ssh_key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.sg.id]

  tags = {
    Name = each.key
  }
}
