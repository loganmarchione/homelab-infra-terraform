################################################################################
### DNS
################################################################################

########################################
### Zone and NS records
########################################

resource "aws_route53_zone" "loganmarchione_com" {
  name = "loganmarchione.com"
}

resource "aws_route53_record" "loganmarchione_com_nameservers" {
  zone_id         = aws_route53_zone.loganmarchione_com.zone_id
  name            = aws_route53_zone.loganmarchione_com.name
  type            = "NS"
  ttl             = "3600"
  allow_overwrite = true
  records         = aws_route53_zone.loganmarchione_com.name_servers
}

########################################
### All other records
########################################

resource "aws_route53_record" "loganmarchione_com_mx_fastmail" {
  zone_id = aws_route53_zone.loganmarchione_com.zone_id
  name    = ""
  type    = "MX"
  ttl     = "3600"
  records = [
    "10 in1-smtp.messagingengine.com",
    "20 in2-smtp.messagingengine.com"
  ]
}

resource "aws_route53_record" "loganmarchione_com_txt" {
  zone_id = aws_route53_zone.loganmarchione_com.zone_id
  name    = ""
  type    = "TXT"
  ttl     = "3600"
  records = [
    "v=spf1 include:spf.messagingengine.com ~all",
    "brave-ledger-verification=e4da6b4a49ab43dba4926c5564f8bc0c34a40883869f2d1f6fe8886108814e82"
  ]
}

resource "aws_route53_record" "loganmarchione_com_cname_dkim" {
  count   = 3
  zone_id = aws_route53_zone.loganmarchione_com.zone_id
  name    = "fm${count.index + 1}._domainkey"
  type    = "CNAME"
  ttl     = "3600"
  records = [
    "fm${count.index + 1}.loganmarchione.com.dkim.fmhosted.com"
  ]
}

resource "aws_route53_record" "loganmarchione_com_bluesky" {
  zone_id = aws_route53_zone.loganmarchione_com.zone_id
  name    = "_atproto"
  type    = "TXT"
  ttl     = "3600"
  records = [
    "did=did:plc:p3k25pmexqzfvuczgjzxh5nk"
  ]
}

########################################
### Email autodiscovery
########################################
# https://www.fastmail.help/hc/en-us/articles/360060591153-Manual-DNS-configuration

resource "aws_route53_record" "loganmarchione_com_autodiscovery_submissions" {
  zone_id = aws_route53_zone.loganmarchione_com.zone_id
  name    = "_submissions._tcp.${aws_route53_zone.loganmarchione_com.name}"
  type    = "SRV"
  ttl     = "3600"
  records = [
    "0 1 465 smtp.fastmail.com"
  ]
}

resource "aws_route53_record" "loganmarchione_com_autodiscovery_imaps" {
  zone_id = aws_route53_zone.loganmarchione_com.zone_id
  name    = "_imaps._tcp.${aws_route53_zone.loganmarchione_com.name}"
  type    = "SRV"
  ttl     = "3600"
  records = [
    "0 1 993 imap.fastmail.com"
  ]
}


resource "aws_route53_record" "loganmarchione_com_autodiscovery_autodiscover" {
  zone_id = aws_route53_zone.loganmarchione_com.zone_id
  name    = "_autodiscover._tcp.${aws_route53_zone.loganmarchione_com.name}"
  type    = "SRV"
  ttl     = "3600"
  records = [
    "0 1 443 autodiscover.fastmail.com"
  ]
}


resource "aws_route53_record" "loganmarchione_com_autodiscovery_carddavs" {
  zone_id = aws_route53_zone.loganmarchione_com.zone_id
  name    = "_carddavs._tcp.${aws_route53_zone.loganmarchione_com.name}"
  type    = "SRV"
  ttl     = "3600"
  records = [
    "0 1 443 carddav.fastmail.com"
  ]
}

resource "aws_route53_record" "loganmarchione_com_autodiscovery_caldavs" {
  zone_id = aws_route53_zone.loganmarchione_com.zone_id
  name    = "_caldavs._tcp.${aws_route53_zone.loganmarchione_com.name}"
  type    = "SRV"
  ttl     = "3600"
  records = [
    "0 1 443 caldav.fastmail.com"
  ]
}

################################################################################
### Module for static site
################################################################################

module "static_site_loganmarchione_com" {
  depends_on = [
    aws_route53_zone.loganmarchione_com,
    aws_route53_record.loganmarchione_com_nameservers
  ]

  source = "github.com/loganmarchione/terraform-aws-static-site?ref=0.1.6"

  providers = {
    aws.us-east-1 = aws.us-east-1
  }

  # The domain name of the site (**MUST** match the Route53 hosted zone name (e.g., `domain.com`)
  domain_name = "loganmarchione.com"

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

module "iam_github_oidc_role_loganmarchione_com" {
  source = "github.com/terraform-aws-modules/terraform-aws-iam//modules/iam-role?ref=v6.1.0"

  enable_github_oidc = true
  name = "GitHubActionsOIDC-loganmarchione-com"
  use_name_prefix = false
  policies = {
    SiteUpdating-loganmarchione-com = module.static_site_loganmarchione_com.site_updating_iam_policy_arn
  }
  oidc_wildcard_subjects = ["loganmarchione/loganmarchione.com:*"]
}
