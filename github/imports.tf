# this was only needed on the initial import, not required anymore
#import {
#  for_each = var.repos
#  to       = github_repository.this[each.key]
#  id       = each.key
#}

#import {
#  for_each = local.active_repos
#  to       = github_repository_vulnerability_alerts.this[each.key]
#  id       = each.key
#}
