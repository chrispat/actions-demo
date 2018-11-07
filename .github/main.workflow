workflow "File Test" {
  on = "issue_comment"
  resolves = ["dump-env"]
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
