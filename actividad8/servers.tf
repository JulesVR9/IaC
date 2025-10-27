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

locals {
  instances = {
    dev = {
      ami           = data.aws_ami.ubuntu.id
      instance_type = "t3.micro"
    }
    qa = {
      ami           = data.aws_ami.ubuntu.id
      instance_type = "t3.micro"
    }
    prod = {
      ami           = data.aws_ami.ubuntu.id
      instance_type = "t3.micro"
    }
  }
}

variable "public_key" {
  description = "Paths to the public key"
  type        = string
  default     = "~/.ssh/ec2.pub"
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "ec2"
  public_key = file(var.public_key)
}

resource "aws_instance" "this" {
  for_each                    = local.instances
  ami                         = each.value.ami
  instance_type               = each.value.instance_type
  key_name                    = aws_key_pair.ssh_key.key_name
  associate_public_ip_address = true

  tags = {
    Name = each.key
  }
}

output "aws_imstances" {
  value = [for instance in aws_instance.this : instance.public_ip]
}
