################################################################################
### AWS
################################################################################

# Needed because CloudFront can only use ACM certs generated in us-east-1
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}
