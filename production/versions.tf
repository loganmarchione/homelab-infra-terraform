terraform {
  required_version = ">= 1.0.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.22.0"
    }
    b2 = {
      source  = "Backblaze/b2"
      version = "~> 0.11.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.12.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.69.0"
    }
  }
}
