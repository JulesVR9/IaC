# Configuración de Terraform y proveedores
terraform { 
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  required_version = ">= 1.0"
}

# Configurar el provider de AWS
provider "aws" {
  region = "us-east-2" # Cambia a tu región deseada
}

# Crear una instancia EC2
resource "aws_instance" "julia_server_terr" {
  ami           = "ami-0cfde0ea8edd312d4" # Ubuntu 22.04 LTS (ejemplo para us-east-2)
  instance_type = "t3.micro"

  tags = {
    Name = "JuliaServerTerraform"
  }

  # Opcional: habilitar acceso SSH
  # key_name = "mi_llave_ssh" # Si tienes un keypair en AWS
  # vpc_security_group_ids = ["sg-xxxxxx"] # Si quieres asociar un security group específico
}

# Salida de información de la instancia
output "instance_id" {
  description = "ID de la instancia EC2 creada"
  value       = aws_instance.julia_server_terr.id
}

output "instance_public_ip" {
  description = "IP pública de la instancia"
  value       = aws_instance.julia_server_terr.public_ip
}

