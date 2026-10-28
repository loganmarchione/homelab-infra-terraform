variable "github_token" {
  description = "GitHub fine-grained PAT"
  sensitive   = true
  type        = string
}

variable "repos" {
  description = "Map of GitHub repositories (keyed by repo name) and their settings"
  type = map(object({
    allow_auto_merge                = optional(bool, false)
    allow_forking                   = optional(bool, true)
    allow_merge_commit              = optional(bool, false)
    allow_rebase_merge              = optional(bool, false)
    allow_squash_merge              = optional(bool, true)
    allow_update_branch             = optional(bool, false)
    archived                        = optional(bool, false)
    delete_branch_on_merge          = optional(bool, true)
    description                     = optional(string)
    has_discussions                 = optional(bool, false)
    has_issues                      = optional(bool, true)
    has_projects                    = optional(bool, false)
    has_wiki                        = optional(bool, false)
    homepage_url                    = optional(string)
    is_template                     = optional(bool, false)
    merge_commit_message            = optional(string, "PR_TITLE")
    merge_commit_title              = optional(string, "MERGE_MESSAGE")
    secret_scanning                 = optional(bool, true)
    secret_scanning_push_protection = optional(bool, true)
    squash_merge_commit_message     = optional(string, "COMMIT_MESSAGES")
    squash_merge_commit_title       = optional(string, "COMMIT_OR_PR_TITLE")
    topics                          = optional(list(string), [])
    visibility                      = optional(string, "public")
    vulnerability_alerts            = optional(bool, true)
    web_commit_signoff_required     = optional(bool, false)
  }))
}
