workflow "Check Commentor Reputation" {
  on = "issue_comment"
  resolves = ["Filter4"]
}

action "Reputation Checker" {
  uses = "./.github/reputation-checker"
  secrets = ["GITHUB_TOKEN"]
  env = {
    MIN_FOLLOWER_COUNT = "5"
  }
}

action "GitHub Action for npm" {
  uses = "actions/npm@59b64a598378f31e49cb76f27d6f3312b582f680"
  needs = ["Reputation Checker"]
}

action "Filter1" {
  uses = "actions/bin/filter@d820d56839906464fb7a57d1b4e1741cf5183efa"
  needs = ["Reputation Checker"]
}

action "GitHub Action for AWS" {
  uses = "actions/aws/cli@efb074ae4510f2d12c7801e4461b65bf5e8317e6"
  needs = ["Reputation Checker"]
}

action "Filter2" {
  uses = "actions/bin/filter@d820d56839906464fb7a57d1b4e1741cf5183efa"
  needs = ["Filter1", "GitHub Action for AWS"]
}

action "Filter3" {
  uses = "actions/bin/filter@d820d56839906464fb7a57d1b4e1741cf5183efa"
  needs = ["Reputation Checker"]
}


action "Filter4" {
  uses = "actions/bin/filter@d820d56839906464fb7a57d1b4e1741cf5183efa"
  needs = ["Filter2", "Filter3"]
}
