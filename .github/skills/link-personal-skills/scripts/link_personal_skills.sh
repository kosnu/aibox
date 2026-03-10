#!/usr/bin/env bash
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel)"
skills_root="$repo_root/.github/skills"
personal_root="$HOME/.copilot/skills"

if [[ ! -d "$skills_root" ]]; then
  echo "No repository skills found at $skills_root" >&2
  exit 1
fi

mkdir -p "$personal_root"

linked=0
for skill_dir in "$skills_root"/*; do
  [[ -d "$skill_dir" ]] || continue
  skill_name="$(basename "$skill_dir")"
  target="$personal_root/$skill_name"
  ln -sfn "$skill_dir" "$target"
  echo "linked: $target -> $skill_dir"
  linked=$((linked + 1))
done

if [[ "$linked" -eq 0 ]]; then
  echo "No skill directories to link under $skills_root" >&2
  exit 1
fi
