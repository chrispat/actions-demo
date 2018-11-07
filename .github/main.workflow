workflow "File Test" {
  on = "issue_comment"
  resolves = ["Reputation Checker"]
}

action "dump-event" {
  uses = "docker://debian:latest"
  args = "cat /github/workflow/event.json"
}

action "dump-env" {
  uses = "docker://debian:latest"
  needs = ["dump-event"]
  args = "env"
  secrets = ["GITHUB_TOKEN"]
}

action "Reputation Checker" {
  uses = "./.github/reputation-checker"
  needs = ["dump-env"]
  secrets = ["GITHUB_TOKEN"]
}
