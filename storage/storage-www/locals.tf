locals {
   aws_s3_bucket_bucket_name	                             = "www"
   aws_s3_bucket_force_destroy                               = true 
   aws_s3_bucket_public_access_block_block_public_acls       = false
   aws_s3_bucket_public_access_block_public_policy           = false
   aws_s3_bucket_public_access_ignore_public_acls            = false
   aws_s3_bucket_public_access_restrict_public_buckets       = false
   aws_s3_bucket_website_configuration_index_document_suffix = "index.html"
}


