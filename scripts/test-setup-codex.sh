#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SETUP_SCRIPT="$PROJECT_ROOT/scripts/setup-codex.sh"

if ! tmp_home="$(mktemp -d 2>/dev/null)"; then
  tmp_home="$(mktemp -d -t setup-codex-test)"
fi
trap 'rm -rf "$tmp_home"' EXIT

log_first="$(mktemp "$tmp_home/setup-codex-test-1.XXXXXX.log")"
log_second="$(mktemp "$tmp_home/setup-codex-test-2.XXXXXX.log")"
log_third="$(mktemp "$tmp_home/setup-codex-test-3.XXXXXX.log")"
log_fourth="$(mktemp "$tmp_home/setup-codex-test-4.XXXXXX.log")"

echo "[test] 初回実行でリンクが作成されること"
HOME="$tmp_home" bash "$SETUP_SCRIPT" >"$log_first"

[ -d "$tmp_home/.agents/skills" ]
[ ! -L "$tmp_home/.agents/skills" ]
[ -L "$tmp_home/.agents/skills/setup-codex-home" ]

echo "[test] 再実行で冪等（skip）になること"
HOME="$tmp_home" bash "$SETUP_SCRIPT" >"$log_second"
grep -q "^\[skip\]" "$log_second"

echo "[test] config.toml はリンクされず既存ファイルも保持されること"
rm -f "$tmp_home/.codex/config.toml"
echo "local" >"$tmp_home/.codex/config.toml"
HOME="$tmp_home" bash "$SETUP_SCRIPT" >"$log_third"
[ ! -e "$tmp_home/.codex/config.toml.bak" ]
[ ! -L "$tmp_home/.codex/config.toml" ]
grep -q "^local$" "$tmp_home/.codex/config.toml"

echo "[test] config.toml がなければ通常ファイルとして作成されること"
rm -f "$tmp_home/.codex/config.toml" "$tmp_home/.codex/config.toml.bak"
HOME="$tmp_home" bash "$SETUP_SCRIPT" >"$log_third"
[ ! -L "$tmp_home/.codex/config.toml" ]
cmp -s "$PROJECT_ROOT/.codex/config.toml" "$tmp_home/.codex/config.toml"

echo "[test] repo config.toml への既存リンクは解除され、backup があれば復元されること"
rm -f "$tmp_home/.codex/config.toml" "$tmp_home/.codex/config.toml.bak"
ln -s "$PROJECT_ROOT/.codex/config.toml" "$tmp_home/.codex/config.toml"
echo "home" >"$tmp_home/.codex/config.toml.bak"
HOME="$tmp_home" bash "$SETUP_SCRIPT" >"$log_third"
[ ! -L "$tmp_home/.codex/config.toml" ]
grep -q "^home$" "$tmp_home/.codex/config.toml"

echo "[test] repo config.toml への既存リンクは backup がなければ通常ファイルとしてコピーされること"
rm -f "$tmp_home/.codex/config.toml" "$tmp_home/.codex/config.toml.bak"
ln -s "$PROJECT_ROOT/.codex/config.toml" "$tmp_home/.codex/config.toml"
HOME="$tmp_home" bash "$SETUP_SCRIPT" >"$log_third"
[ ! -L "$tmp_home/.codex/config.toml" ]
cmp -s "$PROJECT_ROOT/.codex/config.toml" "$tmp_home/.codex/config.toml"

echo "[test] source から削除済みの子リンクが削除されること"
ln -s "$PROJECT_ROOT/.agents/skills/removed-skill" "$tmp_home/.agents/skills/removed-skill"
HOME="$tmp_home" bash "$SETUP_SCRIPT" >"$log_fourth"
[ ! -e "$tmp_home/.agents/skills/removed-skill" ]
[ ! -L "$tmp_home/.agents/skills/removed-skill" ]

echo "[ok] all checks passed"
