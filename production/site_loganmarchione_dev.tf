################################################################################
### DNS
################################################################################

########################################
### Zone and NS records
########################################

resource "aws_route53_zone" "loganmarchione_dev" {
  name = "loganmarchione.dev"
}

resource "aws_route53_record" "loganmarchione_dev_nameservers" {
  zone_id         = aws_route53_zone.loganmarchione_dev.zone_id
  name            = aws_route53_zone.loganmarchione_dev.name
  type            = "NS"
  ttl             = "3600"
  allow_overwrite = true
  records         = aws_route53_zone.loganmarchione_dev.name_servers
}

################################################################################
### Module for static site
################################################################################

module "static_site_loganmarchione_dev" {
  depends_on = [
    aws_route53_zone.loganmarchione_dev,
    aws_route53_record.loganmarchione_dev_nameservers
  ]

  source = "github.com/loganmarchione/terraform-aws-static-site?ref=0.1.6"

  providers = {
    aws.us-east-1 = aws.us-east-1
  }

  # The domain name of the site (**MUST** match the Route53 hosted zone name (e.g., `domain.com`)
  domain_name = "loganmarchione.dev"

  # Since this is a static site, we probably don't need versioning, since our source files are stored in git
  bucket_versioning_logs = false
  bucket_versioning_site = false

  # CloudFront settings
  cloudfront_compress                     = true
  cloudfront_default_root_object          = "index.html"
  cloudfront_enabled                      = true
  cloudfront_function_create              = true
  cloudfront_function_filename            = "function.js"
  cloudfront_function_name                = "ReWrites"
  cloudfront_http_version                 = "http2and3"
  cloudfront_ipv6                         = true
  cloudfront_price_class                  = "PriceClass_100"
  cloudfront_ssl_minimum_protocol_version = "TLSv1.2_2021"
  cloudfront_ttl_min                      = 3600
  cloudfront_ttl_default                  = 86400
  cloudfront_ttl_max                      = 2592000
  cloudfront_viewer_protocol_policy       = "redirect-to-https"

  # IAM
  iam_policy_site_updating = true

  # Upload default files
  upload_index  = false
  upload_robots = false
  upload_404    = false
}

################################################################################
### Module for GitHub OIDC role
################################################################################

module "iam_github_oidc_role_loganmarchione_dev" {
  source = "github.com/terraform-aws-modules/terraform-aws-iam//modules/iam-github-oidc-role?ref=v5.54.1"

  name = "GitHubActionsOIDC-loganmarchione-dev"
  policies = {
    SiteUpdating-loganmarchione-dev = module.static_site_loganmarchione_dev.site_updating_iam_policy_arn
  }
  subjects = ["loganmarchione/loganmarchione.com:*"]
}
