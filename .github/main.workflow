workflow "File Test" {
  on = "push"
  resolves = ["list-files"]
}

action "100-mb-file" {
  uses = "docker://debian:latest"
  args = "dd if=/dev/urandom of=file100mb.txt bs=1048576 count=100"
}

action "200-mb-file" {
  uses = "docker://debian:latest"
  args = "dd if=/dev/urandom of=file100mb.txt bs=1048576 count=100"
  needs = ["100-mb-file"]
}

action "300-mb-file" {
  uses = "docker://debian:latest"
  args = "dd if=/dev/urandom of=file100mb.txt bs=1048576 count=100"
  needs = ["100-mb-file"]
}

action "list-files" {
   uses = "docker://debian:latest"
   args = "ls -la"
   needs = ["200-mb-file", "300-mb-file"]
}
