terraform {
  required_version = ">= 1.0.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.91.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.2.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.49.0"
    }
  }
}
