################################################################################
### Module for OIDC provider
################################################################################

module "oidc_provider" {
  source = "github.com/terraform-aws-modules/terraform-aws-iam?ref=v5.46.0//modules/iam-github-oidc-provider"
}
