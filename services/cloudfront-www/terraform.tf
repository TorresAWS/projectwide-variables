terraform {
    backend "s3" {
        key = "services/cloudfront-www/cloudfront-www.tfstate"
        region = "us-east-1"
        profile  = "Infrastructure"
   }
}
