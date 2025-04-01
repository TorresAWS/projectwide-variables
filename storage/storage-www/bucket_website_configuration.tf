resource "aws_s3_bucket_website_configuration" "my-config" {
  provider    =  aws.Infrastructure
  bucket      = aws_s3_bucket.domain.id
  index_document {
       suffix = local.aws_s3_bucket_website_configuration_index_document_suffix 
  }
}
