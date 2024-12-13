terraform {
  required_version = ">= 1.0.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.81.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.48.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.45.0"
    }
  }
}
