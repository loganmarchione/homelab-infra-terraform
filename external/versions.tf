terraform {
  required_version = ">= 1.11.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.67.0"
    }
    b2 = {
      source  = "Backblaze/b2"
      version = "~> 0.14.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.26.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.103.0"
    }
  }
}
