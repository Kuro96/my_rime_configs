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

if [ "$target_dir" = "$repo_dir" ]; then
  printf 'refusing to deploy into source repo: %s\n' "$repo_dir" >&2
  exit 2
fi

copy_tree() {
  src=$1
  if [ -d "$src" ]; then
    cp -a "$src"/. "$target_dir"/
  fi
}

copy_tree "$repo_dir/common"
copy_tree "$repo_dir/private"
copy_tree "$platform_dir"

printf 'deployed %s Rime config to %s\n' "$platform" "$target_dir"
