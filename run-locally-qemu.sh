#!/usr/bin/env bash

set -eux -o pipefail

# Build the machine image
# TODO: build the base-image link off in an XDG directory probably
nix build \
  --override-input nixek "/home/esk/dev/overlay" \
  --impure \
  --expr 'with (builtins.getFlake (builtins.toString ./.)); (ci.jobs.demo-job { info = "TODO"; }).machine.qemu' \
  -o ./base-image

rm -f ./local-run.qcow2
# Create a write overlay for this run
# TODO: manage this off in XDG directories somewhere, name it after the reproducible hash
qemu-img create -b ./base-image/nixos.qcow2 -F qcow2 -f qcow2 ./local-run.qcow2

trap 'rm -f ./local-run.qcow2' EXIT

# Make the config
mkdir -p mnt
cat > mnt/config.json <<EOF
{
  "name": "demo-job",
  "commit": "main",
  "ref_": "main",
  "repo": "/mnt/nixos-config/example-project",
  "root": "/tmp/nixekcid"
}
EOF


qemu-kvm -drive file=./local-run.qcow2,if=virtio \
  -fsdev local,security_model=passthrough,id=fsdev0,path=$(pwd)/mnt -device virtio-9p-pci,id=fs0,fsdev=fsdev0,mount_tag=nixek-config \
  -nographic

# TODO: actually do ci stuff I guess
