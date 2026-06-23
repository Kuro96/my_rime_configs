#!/usr/bin/env sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

target_dir=${1:-.}
exec sh "$script_dir/deploy-platform.sh" ibus-rime "$target_dir"
