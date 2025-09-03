terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

# Crear bucket S3 sin ACL (privado por defecto)
resource "aws_s3_bucket" "julia_bucket" {
  bucket = "julia-bucket-terraform" # recuerda: nombre único global
  tags = {
    Name        = "JuliaS3Bucket"
    Environment = "Dev"
  }
}
