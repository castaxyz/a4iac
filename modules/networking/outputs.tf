output "vpc_id" {
  description = "ID of the VPC."
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "List of all public subnet IDs."
  value       = aws_subnet.public[*].id
}

output "public_subnet_id" {
  description = "ID of the first public subnet."
  value       = aws_subnet.public[0].id
}

output "web_security_group_id" {
  description = "ID of the web security group (HTTP/SSH)."
  value       = aws_security_group.web_sg.id
}

output "db_security_group_id" {
  description = "ID of the database security group (MySQL)."
  value       = aws_security_group.db_sg.id
}
