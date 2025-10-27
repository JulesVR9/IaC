# variables.tf
variable "public_key" {
  description = "Path to the public key"
  type        = string
  default     = "~/.ssh/ec2.pub"
}
