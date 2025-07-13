terraform {
  required_version = ">= 1.0.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.3.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.6.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.59.0"
    }
  }
}
