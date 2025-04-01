################################################################################
### DNS
################################################################################

########################################
### Zone and NS records
########################################

resource "cloudflare_zone" "loganandmaria_com" {
  name = "loganandmaria.com"

  account = {
    id = var.cloudflare_account_id
  }
  type = "full"
}

########################################
### All other records
########################################

resource "cloudflare_dns_record" "loganandmaria_com_a" {
  zone_id = cloudflare_zone.loganandmaria_com.id
  name    = cloudflare_zone.loganandmaria_com.name
  type    = "A"
  ttl     = 3600
  content = digitalocean_droplet.web01.ipv4_address
  proxied = false
}

resource "cloudflare_dns_record" "loganandmaria_com_aaaa" {
  zone_id = cloudflare_zone.loganandmaria_com.id
  name    = cloudflare_zone.loganandmaria_com.name
  type    = "AAAA"
  ttl     = 3600
  content = digitalocean_droplet.web01.ipv6_address
  proxied = false
}

resource "cloudflare_dns_record" "loganandmaria_com_a_www" {
  zone_id = cloudflare_zone.loganandmaria_com.id
  name    = "www.${cloudflare_zone.loganandmaria_com.name}"
  type    = "A"
  ttl     = 3600
  content = digitalocean_droplet.web01.ipv4_address
  proxied = false
}

resource "cloudflare_dns_record" "loganandmaria_com_aaaa_www" {
  zone_id = cloudflare_zone.loganandmaria_com.id
  name    = "www.${cloudflare_zone.loganandmaria_com.name}"
  type    = "AAAA"
  ttl     = 3600
  content = digitalocean_droplet.web01.ipv6_address
  proxied = false
}

resource "cloudflare_dns_record" "loganandmaria_com_caa" {
  for_each = toset(local.lets_encrypt_caa_record_tags)

  zone_id = cloudflare_zone.loganandmaria_com.id
  name    = cloudflare_zone.loganandmaria_com.name
  type    = "CAA"
  ttl     = 3600
  data = {
    flags = 0
    tag   = each.value
    value = "letsencrypt.org"
  }
}

resource "cloudflare_dns_record" "loganandmaria_com_mx" {
  for_each = { for key, val in local.loganandmaria_mx_records : key => val }

  zone_id  = cloudflare_zone.loganandmaria_com.id
  name     = cloudflare_zone.loganandmaria_com.name
  type     = "MX"
  ttl      = 3600
  content  = each.value.content
  proxied  = false
  priority = each.value.priority
}

resource "cloudflare_dns_record" "loganandmaria_com_txt" {
  zone_id = cloudflare_zone.loganandmaria_com.id
  name    = cloudflare_zone.loganandmaria_com.name
  type    = "TXT"
  ttl     = 3600
  content = "\"v=spf1 include:_spf.google.com ~all\""
  proxied = false
}
