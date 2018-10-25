workflow "File Test" {
  on = "push"
  resolves = ["100-mb-file"]
}

action "100-mb-file" {
  uses = "docker://debian:latest"
  runs = "/bin/sh"
  args = "dd if=/dev/urandom of=file100mb.txt bs=1048576 count=100"
}
