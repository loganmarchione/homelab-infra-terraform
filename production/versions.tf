terraform {
  required_version = ">= 1.0.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.11.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.9.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.66.0"
    }
  }
}
