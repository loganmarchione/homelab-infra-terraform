terraform {
  required_version = ">= 1.0.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.4.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.7.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.61.0"
    }
  }
}
