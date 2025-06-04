terraform {
  required_version = ">= 1.0.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.99.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.5.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.55.0"
    }
  }
}
