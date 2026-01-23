################################################################################
### Module for OIDC provider
################################################################################

module "oidc_provider" {
  source = "github.com/terraform-aws-modules/terraform-aws-iam//modules/iam-oidc-provider?ref=v6.4.0"
}
