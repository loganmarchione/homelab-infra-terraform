################################################################################
### SES
################################################################################

########################################
### loganmarchione.com
########################################

# Create the domain
resource "aws_ses_domain_identity" "loganmarchione_com" {
  domain = aws_route53_zone.loganmarchione_com.name
}

# Verify the domain
resource "aws_ses_domain_identity_verification" "loganmarchione_com" {
  domain = aws_ses_domain_identity.loganmarchione_com.id
  depends_on = [
    aws_route53_record.loganmarchione_com_txt_ses
  ]
}

# DKIM
resource "aws_ses_domain_dkim" "loganmarchione_com" {
  domain = aws_ses_domain_identity.loganmarchione_com.domain
}

########################################
### homelab_domain
########################################

# Create the domain
resource "aws_ses_domain_identity" "homelab_domain" {
  domain = var.homelab_domain
}

# Verify the domain
resource "aws_ses_domain_identity_verification" "homelab_domain" {
  domain = aws_ses_domain_identity.homelab_domain.id
  depends_on = [
    cloudflare_dns_record.homelab_domain_txt_aws_ses
  ]
}

# DKIM
resource "aws_ses_domain_dkim" "homelab_domain" {
  domain = aws_ses_domain_identity.homelab_domain.domain
}

################################################################################
### DNS
################################################################################

########################################
### loganmarchione.com
########################################

# Create DNS records for SES
resource "aws_route53_record" "loganmarchione_com_txt_ses" {
  zone_id = aws_route53_zone.loganmarchione_com.id
  name    = "_amazonses.${aws_ses_domain_identity.loganmarchione_com.domain}"
  type    = "TXT"
  ttl     = "3600"
  records = [
    aws_ses_domain_identity.loganmarchione_com.verification_token
  ]
}

# Create DNS records for DKIM
resource "aws_route53_record" "loganmarchione_com_cname_ses" {
  for_each = toset(aws_ses_domain_dkim.loganmarchione_com.dkim_tokens)

  zone_id = aws_route53_zone.loganmarchione_com.id
  name    = "${each.key}._domainkey"
  type    = "CNAME"
  ttl     = "3600"
  records = [
    "${each.key}.dkim.amazonses.com"
  ]
}

########################################
### homelab_domain
########################################

# Create DNS records for SES
resource "cloudflare_dns_record" "homelab_domain_txt_aws_ses" {
  zone_id = cloudflare_zone.homelab_domain.id
  name    = "_amazonses"
  type    = "TXT"
  ttl     = 3600
  content = aws_ses_domain_identity.homelab_domain.verification_token
  proxied = false
}

# Create DNS records for DKIM
resource "cloudflare_dns_record" "homelab_domain_cname_aws_ses" {
  for_each = toset(aws_ses_domain_dkim.homelab_domain.dkim_tokens)

  zone_id = cloudflare_zone.homelab_domain.id
  name    = "${each.key}._domainkey"
  type    = "CNAME"
  ttl     = 3600
  content = "${each.key}.dkim.amazonses.com"
  proxied = false
}
