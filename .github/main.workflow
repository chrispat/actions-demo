workflow "File Test" {
  on = "push"
  resolves = [
    "ip-info",
    "machine-id-1",
  ]
}

action "100-mb-file" {
  uses = "docker://debian:latest"
  args = "dd if=/dev/urandom of=file100mb.txt bs=1048576 count=100"
}

action "200-mb-file" {
  uses = "docker://debian:latest"
  args = "dd if=/dev/urandom of=file200mb.txt bs=1048576 count=200"
  needs = ["100-mb-file"]
}

action "300-mb-file" {
  uses = "docker://debian:latest"
  args = "dd if=/dev/urandom of=file300mb.txt bs=1048576 count=300"
  needs = ["100-mb-file"]
}

action "list-files" {
  uses = "docker://debian:latest"
  args = "ls -la"
  needs = ["200-mb-file", "300-mb-file"]
}

action "ip-info" {
  uses = "docker://appropriate/curl"
  args = "ifconfig.co"
  needs = ["list-files"]
}

action "machine-id-1" {
  needs = ["100-mb-file"]
  uses = "actions/docker/cli@6495e70"
  args = "run -i --rm -v /etc:/hostetc alpine cat /etc/machine-id"
}
