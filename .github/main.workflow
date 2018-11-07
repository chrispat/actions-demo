workflow "Check Commentor Reputation" {
  on = "issue_comment"
  resolves = ["Reputation Checker"]
}

action "Reputation Checker" {
  uses = "./.github/reputation-checker"
  secrets = ["GITHUB_TOKEN"]
  env = {
    MIN_FOLLOWER_COUNT = "100"
  }
}
