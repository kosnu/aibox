#!/usr/bin/env bash
set -euo pipefail

# Codex notify passes a single JSON argument.
notification="${1:-}"
[ -n "$notification" ] || exit 0

# Skip if notifications are unavailable in the current terminal.
[ -S /tmp/cmux.sock ] || exit 0

type=$(printf '%s' "$notification" | jq -r '."type" // ""')
[ "$type" = "agent-turn-complete" ] || exit 0

assistant_message=$(printf '%s' "$notification" | jq -r '."last-assistant-message" // "Turn complete"')
user_message=$(printf '%s' "$notification" | jq -r '."input-messages"[0] // ""')

title="Codex"
body="$assistant_message"
[ -n "$user_message" ] && body="$assistant_message | $user_message"

cmux notify --title "$title" --body "$body" >/dev/null 2>&1 || true
