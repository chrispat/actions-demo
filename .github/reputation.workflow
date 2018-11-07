workflow "File Test" {
  on = "issue_comment"
  resolves = ["Reputation Checker"]
}

action "Reputation Checker" {
  uses = "./.github/reputation-checker"
  secrets = ["GITHUB_TOKEN"]
}
