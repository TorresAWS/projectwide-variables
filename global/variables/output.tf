output "domain" {
  description = ""
  value       = var.domain  
}
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
output "region" {
  value = data.aws_region.current.name
}
output "ses-email" {
  description = ""
  value       = var.ses-email  
}
output "bucket-name" {
  description = ""
  value       = var.bucket-name  
}



