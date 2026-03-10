#!/usr/bin/env bash
set -euo pipefail

# Compatibility shim kept for older local wiring.
# Codex external notify currently emits only `agent-turn-complete`, so
# approval requests should use `tui.notifications = ["approval-requested"]`.
notification="${1:-}"
[ -n "$notification" ] || exit 0

# Reuse the completion notifier when this script is still referenced.
exec "$(dirname "$0")/stop-notify.sh" "$notification"
