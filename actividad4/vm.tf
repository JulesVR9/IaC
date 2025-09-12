resource "aws_instance" "julia_server_terr" {
  ami           = "ami-0cfde0ea8edd312d4"
  instance_type = "t3.micro"

  tags = {
    Name = "JuliaServerTerraform"
  }
}

output "server_name" {
  value = aws_instance.julia_server_terr.tags.Name
}
