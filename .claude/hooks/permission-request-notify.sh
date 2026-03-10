#!/bin/bash
# Skip if not in cmux
[ -S /tmp/cmux.sock ] || exit 0

EVENT=$(cat)
EVENT_TYPE=$(echo "$EVENT" | jq -r '.event // "unknown"')
TOOL=$(echo "$EVENT" | jq -r '.tool_name // ""')

if [ "$EVENT_TYPE" == "PermissionRequest" ]; then
    cmux notify --title "Claude Code" --body "Permission requested for tool: $TOOL"
fi
