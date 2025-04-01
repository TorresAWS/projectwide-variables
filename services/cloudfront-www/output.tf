output "cloudfront_endpoint" {
  description = "Website URL (HTTP) http://"
  value       = "https://${aws_cloudfront_distribution.domain.domain_name}"
}

output "s3_endpoint" {
  description = "S3 hosting URL (HTTP)"
  value       = "http://${data.terraform_remote_state.storage.outputs.aws-s3-bucket-website-configuration-my-config-website-endpoint}"
}
