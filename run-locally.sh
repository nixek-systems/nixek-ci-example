#!/usr/bin/env bash

set -eux -o pipefail

# Build the machine image
nix build --impure --expr 'with (builtins.getFlake (builtins.toString ./.)); (ci.jobs.demo-job { info = "TODO"; }).machine'

# Upload the machine image
echo "TODO"
exit 1

# Run CI, use SSH to monitor it
