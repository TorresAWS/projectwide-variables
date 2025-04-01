resource "aws_cloudfront_distribution" "domain" {
  origin {
    domain_name = "${data.terraform_remote_state.storage.outputs.aws-s3-bucket-website-configuration-my-config-website-endpoint}" 
    origin_id   ="${data.terraform_remote_state.storage.outputs.aws-s3-bucket-domain-bucket-regional-domain-name}"


   custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "http-only"
      origin_read_timeout      = 30
      origin_ssl_protocols = [
        "TLSv1.2",
      ]
    }
}

  provider                     =  aws.Infrastructure
  aliases = ["www.${data.terraform_remote_state.variables.outputs.domain}"]

  enabled = true
    default_root_object = "index.html"

  default_cache_behavior {
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "${data.terraform_remote_state.storage.outputs.aws-s3-bucket-domain-bucket-regional-domain-name}"

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 300 

  }



  viewer_certificate {
    acm_certificate_arn = "${data.terraform_remote_state.certs.outputs.aws-acm-certificate-domain-arn}" 
    ssl_support_method = "sni-only"
  }


  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

}



