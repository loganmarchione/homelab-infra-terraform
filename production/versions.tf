terraform {
  required_version = ">= 1.0.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.9.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.8.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.65.0"
    }
  }
}
