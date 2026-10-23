output "endpoint" {
  description = "Connection endpoint of the DB instance (host:port)."
  value       = aws_db_instance.this.endpoint
}

output "address" {
  description = "Hostname/FQDN of the DB instance (without port)."
  value       = aws_db_instance.this.address
}

output "port" {
  description = "Port on which the DB instance accepts connections."
  value       = aws_db_instance.this.port
}

output "db_name" {
  description = "Name of the initial database created on the instance."
  value       = aws_db_instance.this.db_name
}
