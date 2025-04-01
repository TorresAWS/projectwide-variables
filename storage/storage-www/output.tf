output "aws-s3-bucket-website-configuration-my-config-website-endpoint" {
  description = ""
  value       = aws_s3_bucket_website_configuration.my-config.website_endpoint 
}

output "aws-s3-bucket-domain-bucket-regional-domain-name" {
  description = ""
  value       = aws_s3_bucket.domain.bucket_regional_domain_name 
}

output "aws_s3_bucket-domain-id" {
  description = ""
  value       = aws_s3_bucket.domain.id 
}
