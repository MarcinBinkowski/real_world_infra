# module "ecs_acm" {
#   source  = "terraform-aws-modules/acm/aws"
#   version = "~> 3.3.0"

#   domain_name = var.dns_zone
#   zone_id     = aws_route53_zone.main.id

#   subject_alternative_names = [
#     "*.${var.dns_zone}",
#   ]
# }

module "cdn" {
  source = "terraform-aws-modules/cloudfront/aws"

  aliases = [var.dns_zone]

#   comment             = "My awesome CloudFront"
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  wait_for_deployment = false

#   create_origin_access_identity = true
#   origin_access_identities = {
#     s3_bucket_one = "My awesome CloudFront can access"
#   }

#   logging_config = {
#     bucket = "logs-my-cdn.s3.amazonaws.com"
#   }

  origin = {
    something = {
      domain_name = module.ecs_alb.lb_dns_name
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "match-viewer"
        origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
      }
    }
    s3_one = {
      domain_name = aws_s3_bucket.www.bucket_regional_domain_name
      # s3_origin_config = {
      #   origin_access_identity = "s3_bucket_one"
      # }
    }
  }
  default_root_object = "index.html"

  default_cache_behavior = {
    # use_forwarded_values = false
    # cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    # origin_request_policy_id   = "216adef6-5c7f-47e4-b989-5492eafa07d3"
    # response_headers_policy_id = "60669652-455b-4ae9-85a4-c4c02393f86c"
    
    target_origin_id           = "s3_one"
    viewer_protocol_policy     = "allow-all"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    query_string    = true
  }

  # ordered_cache_behavior = [
  #   {
  #     path_pattern           = "/static/*"
  #     target_origin_id       = "s3_one"
  #     viewer_protocol_policy = "redirect-to-https"

  #     allowed_methods = ["GET", "HEAD", "OPTIONS"]
  #     cached_methods  = ["GET", "HEAD"]
  #     compress        = true
  #     query_string    = true
  #   }
  # ]

  viewer_certificate = {
    acm_certificate_arn = module.cdn_acm.acm_certificate_arn
    ssl_support_method  = "sni-only"
  }
}