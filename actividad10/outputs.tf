# outputs.tf

# Salidas de IPs públicas
output "public_ips" {
  value = [for instance in aws_instance.actividad10_nodes : instance.public_ip]
}

# Salidas de IDs de instancias
output "instance_ids" {
  value = [for instance in aws_instance.actividad10_nodes : instance.id]
}
