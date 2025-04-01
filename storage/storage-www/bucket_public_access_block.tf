resource "aws_s3_bucket_public_access_block" "bucket_access_block" {
  provider                     =  aws.Infrastructure
  bucket = aws_s3_bucket.domain.id
  block_public_acls       = local.aws_s3_bucket_public_access_block_block_public_acls
  block_public_policy     = local.aws_s3_bucket_public_access_block_public_policy
  ignore_public_acls      = local.aws_s3_bucket_public_access_ignore_public_acls
  restrict_public_buckets = local.aws_s3_bucket_public_access_restrict_public_buckets
}
