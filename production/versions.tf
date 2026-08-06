terraform {
  required_version = ">= 1.0.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.57.0"
    }
    b2 = {
      source  = "Backblaze/b2"
      version = "~> 0.13.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.23.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.99.0"
    }
  }
}
