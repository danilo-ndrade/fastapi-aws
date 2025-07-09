output "instance_id" {
  description = "IP Público da instância"
  value       = aws_instance.server.id
}

output "instance_public_ip" {
  description = "IP Público da instância"
  value       = aws_instance.server.public_ip
}

output "instance_public_dns" {
  description = "DNS Público da instância"
  value       = aws_instance.server.public_dns
}

output "ecr_repo" {
  description = "ID do repositório da imagem do docker"
  value       = aws_ecr_repository.repository.id
}
