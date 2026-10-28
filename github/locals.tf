locals {
  active_repos = { for k, v in var.repos : k => v if !v.archived }
}
