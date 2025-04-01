resource "aws_s3_bucket" "domain" {
  provider      =  aws.Infrastructure
  bucket        = "${local.aws_s3_bucket_bucket_name}.${data.terraform_remote_state.variables.outputs.domain}"
  force_destroy = local.aws_s3_bucket_force_destroy 

  # this local provisioner ensured all files from the folder are copied recursively
  provisioner "local-exec" {
        command = "aws s3 cp ../../files/website s3://${aws_s3_bucket.domain.id} --recursive --profile 'Infrastructure' "
  }
}

