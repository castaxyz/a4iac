output "moodle_url" {
  description = "URL to access the Moodle installation."
  value       = "http://${module.compute.public_ip}"
}

output "ec2_public_ip" {
  description = "Public IP address of the Moodle EC2 instance."
  value       = module.compute.public_ip
}

output "rds_endpoint" {
  description = "Connection endpoint of the RDS instance (host:port)."
  value       = module.database.endpoint
}

output "moodle_admin_user" {
  description = "Moodle administrator username."
  value       = var.moodle_admin_user
}

output "instructions" {
  description = "Post-deployment usage notes."
  value       = "Moodle puede tardar entre 4 y 6 minutos en completar la instalación tras el apply. Accede a la URL de moodle_url una vez transcurrido ese tiempo."
}
