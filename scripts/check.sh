#!/usr/bin/env bash
# Checks every plugin in crates/: the layout and names the README asks for,
# then formatting, lints and the headless tests, against the engine checkout
# beside this one (../ponko).
#
#   scripts/check.sh
set -euo pipefail
cd "$(dirname "$0")/.."

if [ ! -f ../ponko/Cargo.toml ]; then
  echo "error: no engine checkout at ../ponko; clone https://gitlab.com/ponkoengine/ponko beside this repository" >&2
  exit 2
fi

problems=0
problem() { echo "error: $*" >&2; problems=$((problems + 1)); }
for dir in crates/*/; do
  dir=${dir%/}
  crate=$(basename "$dir")
  manifest="$dir/Cargo.toml"
  case "$crate" in
    ponko_[a-z0-9]*) ;;
    *) problem "$crate: crates here are named ponko_<thing> (lowercase, '_')" ;;
  esac
  grep -q "^name = \"$crate\"$" "$manifest" || problem "$crate: its package name must be its folder name"
  grep -q '^ponko = { workspace = true' "$manifest" ||
    problem "$crate: depend on the engine with 'ponko = { workspace = true }' (plus the features it needs)"
  if grep -q '^\[profile' "$manifest"; then
    problem "$crate: profiles belong in the root Cargo.toml"
  fi
  for file in README.md AGENTS.md src/lib.rs; do
    [ -f "$dir/$file" ] || problem "$crate: missing $file (the template makes it)"
  done
  ls "$dir"/tests/*.rs > /dev/null 2>&1 || problem "$crate: no headless tests in tests/"
  grep -q '^## Versions' "$dir/README.md" 2>/dev/null ||
    problem "$crate: README.md needs the '## Versions' table (crate version to Ponko version)"
done
if [ "$problems" -gt 0 ]; then
  echo "$problems problem(s) in the layout" >&2
  exit 1
fi

cargo fmt --all --check
cargo clippy --workspace --all-targets -- -D warnings
cargo test --workspace
echo "every plugin passed"
