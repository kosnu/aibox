#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SETUP_SCRIPT="$PROJECT_ROOT/scripts/setup-codex.sh"

tmp_home="$(mktemp -d)"
trap 'rm -rf "$tmp_home"' EXIT

echo "[test] 初回実行でリンクが作成されること"
HOME="$tmp_home" bash "$SETUP_SCRIPT" >/tmp/setup-codex-test-1.log

[ -d "$tmp_home/.codex/skills" ]
[ ! -L "$tmp_home/.codex/skills" ]
[ -L "$tmp_home/.codex/skills/setup-codex-home" ]

echo "[test] 再実行で冪等（skip）になること"
HOME="$tmp_home" bash "$SETUP_SCRIPT" >/tmp/setup-codex-test-2.log
grep -q "^\[skip\]" /tmp/setup-codex-test-2.log

echo "[test] 既存ファイルが .bak に退避されること"
rm -f "$tmp_home/.codex/config.toml"
echo "local" >"$tmp_home/.codex/config.toml"
HOME="$tmp_home" bash "$SETUP_SCRIPT" >/tmp/setup-codex-test-3.log
[ -f "$tmp_home/.codex/config.toml.bak" ]
[ -L "$tmp_home/.codex/config.toml" ]

echo "[ok] all checks passed"
