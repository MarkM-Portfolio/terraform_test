output "private_key_openssh" {
  value     = tls_private_key.this.private_key_openssh
  sensitive = true
}

output "efs_dns_name" {
  value = module.efs.efs_dns_name
}

output "public_ip" {
  value = aws_eip.this.public_ip
}

