# Codex Notification Notes

`.codex/hooks` contains scripts for Codex's `notify` command, not Claude-style
stdin hook events.

- `.codex/hooks/stop-notify.sh`
  - Primary notification script for Codex `notify`
  - Expects one JSON argument from Codex
  - Handles `agent-turn-complete`
- `.codex/hooks/permission-request-notify.sh`
  - Compatibility shim for older local references
  - Codex `notify` does not currently emit approval events
- `.codex/statusline.sh`
  - Still reads JSON from stdin for status line updates

Recommended Codex configuration:

```toml
notify = ["bash", ".codex/hooks/stop-notify.sh"]

[tui]
notifications = ["agent-turn-complete", "approval-requested"]
notification_method = "auto"
```

Notes:

- Codex `notify` passes a single JSON argument to the command.
- Supported external notification event is currently `agent-turn-complete`.
- Approval prompts should use built-in `tui.notifications`, not external
  `notify`.

Required commands:

- `jq`
- `bc`
- `cmux` (optional, only for external notification delivery)
