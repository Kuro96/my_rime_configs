#!/usr/bin/env sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
platform=${1:-}
target_dir=${2:-}

if [ -z "$platform" ] || [ -z "$target_dir" ]; then
  printf 'usage: %s PLATFORM TARGET_RIME_DIR\n' "$0" >&2
  exit 2
fi

platform_dir=$repo_dir/platforms/$platform
if [ ! -d "$platform_dir" ]; then
  printf 'unknown platform: %s\n' "$platform" >&2
  exit 2
fi

target_dir=$(mkdir -p -- "$target_dir" && CDPATH= cd -- "$target_dir" && pwd)

copy_tree() {
  src=$1
  if [ -d "$src" ]; then
    cp -a "$src"/. "$target_dir"/
  fi
}

deploy_default_custom() {
  template=$repo_dir/templates/default.custom.yaml
  default_patch=$platform_dir/default.custom.yaml.patch

  if [ ! -f "$template" ]; then
    printf 'missing default template: %s\n' "$template" >&2
    exit 2
  fi

  cp -- "$template" "$target_dir/default.custom.yaml"
  if [ -f "$default_patch" ]; then
    patch --silent --no-backup-if-mismatch -d "$target_dir" default.custom.yaml < "$default_patch"
  fi
  rm -f -- "$target_dir/default.custom.yaml.patch"
}

copy_tree "$repo_dir/common"
copy_tree "$repo_dir/private"
copy_tree "$platform_dir"
deploy_default_custom

printf 'deployed %s Rime config to %s\n' "$platform" "$target_dir"
