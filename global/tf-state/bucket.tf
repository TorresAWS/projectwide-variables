resource "aws_s3_bucket" "terraform_state" {
  provider        =  aws.Infrastructure
  bucket          =  local.aws_s3_bucket_bucket 
  force_destroy = local.aws_s3_bucket_force_destroy

#  lifecycle {
#    prevent_destroy = true 
#  }
}
