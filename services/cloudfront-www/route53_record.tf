resource "aws_route53_record" "www" {
  provider                     =  aws.Domain
  zone_id = "${data.terraform_remote_state.zones.outputs.zone_id}" 
  name    = "www"
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.domain.domain_name
    zone_id                = aws_cloudfront_distribution.domain.hosted_zone_id
    evaluate_target_health = false 
  }

}
