output "ec2_instance_public_dns_names" {
  value = aws_instance.default.*.public_dns
}

output "ecr_repository_url" {
  value = aws_ecr_repository.default.repository_url
}
