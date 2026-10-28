resource "github_repository" "this" {
  for_each = var.repos

  name = each.key

  allow_auto_merge            = each.value.allow_auto_merge
  allow_forking               = each.value.allow_forking
  allow_merge_commit          = each.value.allow_merge_commit
  allow_rebase_merge          = each.value.allow_rebase_merge
  allow_squash_merge          = each.value.allow_squash_merge
  allow_update_branch         = each.value.allow_update_branch
  archive_on_destroy          = true
  archived                    = each.value.archived
  delete_branch_on_merge      = each.value.delete_branch_on_merge
  description                 = each.value.description
  has_discussions             = each.value.has_discussions
  has_issues                  = each.value.has_issues
  has_projects                = each.value.has_projects
  has_wiki                    = each.value.has_wiki
  homepage_url                = each.value.homepage_url
  is_template                 = each.value.is_template
  merge_commit_message        = each.value.merge_commit_message
  merge_commit_title          = each.value.merge_commit_title
  squash_merge_commit_message = each.value.squash_merge_commit_message
  squash_merge_commit_title   = each.value.squash_merge_commit_title
  topics                      = each.value.topics
  visibility                  = each.value.visibility
  web_commit_signoff_required = each.value.web_commit_signoff_required

  dynamic "security_and_analysis" {
    for_each = each.value.visibility == "public" ? [1] : []
    content {
      secret_scanning {
        status = each.value.secret_scanning ? "enabled" : "disabled"
      }
      secret_scanning_push_protection {
        status = each.value.secret_scanning_push_protection ? "enabled" : "disabled"
      }
    }
  }
}

resource "github_repository_vulnerability_alerts" "this" {
  for_each = local.active_repos

  repository = github_repository.this[each.key].name
  enabled    = each.value.vulnerability_alerts
}
