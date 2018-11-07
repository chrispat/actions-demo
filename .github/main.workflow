workflow "File Test" {
  resolves = [
    "list-files",
  ]
  on = "member"
}

action "dump-event" {
  uses = "docker://debian:latest"
  args = "cat /github/workflow/event.json"
}

action "list-files" {
  uses = "docker://debian:latest"
  needs = ["dump-event"]
  args = "env"
}
